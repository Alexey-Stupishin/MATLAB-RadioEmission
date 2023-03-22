function [k, b, r] = xlinfit(x, y)

N = numel(x);
assert(N == numel(y))

x = reshape(x, [1 numel(x)]);
y = reshape(y, [1 numel(y)]);

sx = sum(x);
sy = sum(y);
sx2 = sum(x.^2);
sy2 = sum(y.^2);
sxy = sum(x.*y);

k = (N*sxy - sx*sy)/(N*sx2 - sx^2);
b = sy/N - k*sx/N;
r = (N*sxy - sx*sy)/sqrt((N*sx2 - sx^2))/(N*sxy - sy^2);

end
