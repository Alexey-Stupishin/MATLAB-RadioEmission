function [Vx, Vy, beta, kb, kyx, kxy, c] = asmPrincComp2D(x, y)

N = numel(x);
assert(N == numel(y))

x = reshape(x, [1 numel(x)]);
y = reshape(y, [1 numel(y)]);

mx = mean(x);
x = x - mx;
my = mean(y);
y = y - my;

kyx = sum(x.*y)/sum(x.^2);
kxy = sum(y.^2)/sum(x.*y);

beta = 0.5 * atan2d(2*sum(x.*y), sum(x.^2 - y.^2));
kb = tand(beta);

sb = sind(beta);
cb = cosd(beta);
Vx = sqrt(sum(( x*cb + y*sb).^2))/numel(x);
Vy = sqrt(sum((-x*sb + y*cb).^2))/numel(x);

c = my - kb*mx;

end
