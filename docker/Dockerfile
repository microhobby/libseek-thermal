FROM debian:buster-slim AS build

# install binutils
RUN apt-get -y update && apt-get install -y \
	libc6 \
	libc6-dev \
	binutils \
	make \
	cmake \
	clang \
	gcc \
	g++ \
	git \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# install deps
RUN apt-get -y update && apt-get install -y \
	libopencv-dev \
	libusb-1.0-0-dev \
	libboost-program-options-dev \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/microhobby/libseek-thermal.git && \
	cd libseek-thermal && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make

FROM debian:buster-slim AS deploy

# install deps
RUN apt-get -y update && apt-get install -y \
	udev \
	libopencv-core3.2 \
	libopencv-stitching3.2 \
	libopencv-shape3.2 \
	libopencv-superres3.2 \
	libopencv-videostab3.2 \
	libopencv-contrib3.2 \
	libusb-1.0-0 \
	libboost-program-options1.67.0 \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# install sudo
RUN apt-get -y update && apt-get install -y \
	sudo \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# add the developer user and add him to sudo group
RUN useradd -m developer && \
	echo "developer:root" | chpasswd && \
	adduser developer sudo

# for use X11
RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	mkdir -p /etc/sudoers.d && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
	chmod 0440 /etc/sudoers.d/developer && \
	chown ${uid}:${gid} -R /home/developer

# add the default user
USER developer
ENV HOME /home/developer

# copy binaries to /usr/bin
COPY --from=build /libseek-thermal/build/examples /usr/bin
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

# copy udev rules
COPY ./90-usb.rules /etc/udev/rules.d/

# make entrypoint executable
RUN sudo chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
