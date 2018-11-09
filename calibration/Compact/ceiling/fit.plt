reset
#f(x) = a+b*x
f(x) = a+b*x+c*x**2+d*x**3+e*x**4
a=1
b=1
c=1
d=1
e=1
FIT_LIMIT = 1e-14
fit f(x) "tofit.csv" using 1:2 via a,b,c,d,e
plot "tofit.csv" using 1:2 with points title "correction", "tofit.csv" using 1:(f($1)) with lines title "fitted function"
