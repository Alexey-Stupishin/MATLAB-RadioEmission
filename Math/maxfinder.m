function [maxs, minl, minr] = maxfinder(x, f, noize, minlng)
%f = [1 2 3 4 5 4 3 4 5 6 5 6 5 6 5 6 7 8 8 8 8 8 9 8 7 6 6 6 6 5 4 5 4 3 2 1]
%noize = 4;
%minlng

maxs = [];
minl = [];
minr = [];

d = diff(f);
sd = sign(d);
dd = diff(sd);
dd(dd == 1) = 0;
dd(dd == -1) = 0;
w = find(dd)+1;
if length(w) < 3
    return
end
if f(1) < f(w(1))
    w = [1 w];
end
if f(end) < f(w(end))
    w = [w length(f)];
end

for k = 1:2:length(w)
    if k+2 > length(w)
        break;
    end
    if x(w(k+2)) - x(w(k)) <= minlng
        continue
    end
    fk1 = (w(k+1)-w(k))/(w(k+2)-w(k))*(f(w(k+2))-f(w(k))) + f(w(k));
    df = f(w(k+1)) - fk1;
    if df >= noize
        maxs = [maxs w(k+1)];
        minl = [minl w(k)];
        minr = [minr w(k+2)];
    end
end

stophere = 1;

end
