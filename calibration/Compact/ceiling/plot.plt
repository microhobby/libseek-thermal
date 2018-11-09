reset
set xrange [0:830]
set yrange [15700:16520]
set y2range [4260:4560]
set logscale y
set logscale y2
set ytics 100
set y2tics 100
plot "ceiling.dat" using 1 with lines title "rcentral", "ceiling.dat" using 2 with lines title "rdevtmp" axes x1y2
