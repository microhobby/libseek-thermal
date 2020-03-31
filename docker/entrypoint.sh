#!/bin/bash

function mount_dev()
{
	sudo mkdir -p /tmp
	sudo mount -t devtmpfs none /tmp
	sudo mkdir -p /tmp/shm
	sudo mount --move /dev/shm /tmp/shm
	sudo mkdir -p /tmp/mqueue
	sudo mount --move /dev/mqueue /tmp/mqueue
	sudo mkdir -p /tmp/pts
	sudo mount --move /dev/pts /tmp/pts
	sudo touch /tmp/console
	sudo mount --move /dev/console /tmp/console
	sudo umount /dev || true
	sudo mount --move /tmp /dev

	# point ptmx
	sudo ln -sf /dev/pts/ptmx /dev/ptmx
	sudo mount -t debugfs nodev /sys/kernel/debug
}

function start_udev()
{
	mount_dev
	if command -v udevd &>/dev/null; then
		sudo unshare --net udevd --daemon &> /dev/null
	else
		sudo unshare --net /lib/systemd/systemd-udevd --daemon &> /dev/null
	fi
	sudo udevadm trigger &> /dev/null
}

function init()
{
	# echo error message, when executable file doesn't exist.
	if CMD=$(command -v "$1" 2>/dev/null); then
		shift
		exec "$CMD" "$@"
	else
		echo "Command not found: $1"
		exit 1
	fi
}

# mount and trigger udev
start_udev

# execute the CMD
init "$@"
