function [Bx, By, Bz] = getLowLouFieldInPoint(LL, d, Phi, coord)
% LL.n = n;
% LL.a = sqrt(lambda);
% LL.mus = T;
% LL.PPd = Y;

cosP = cos(Phi);
sinP = sin(Phi);

X = coord(1)*cosP - (coord(3) + d)*sinP;
Y = coord(2);
Z = coord(1)*sinP + (coord(3) + d)*cosP;

r = sqrt(X^2 + Y^2 + Z^2);
ph = atan2(Y, X);
th = atan2(sqrt(X^2 + Y^2), Z);

cost = cos(th);
sint = sin(th);
V = interp1(LL.mus, LL.PPd, cost);
P = V(1);
dPdm = V(2);
Ps = l_Ps(P, sint);

invr = r^(-LL.n-2);
Br = -dPdm * invr;
Bth = LL.n * Ps * invr;
Bph = LL.a * Ps * P^(1/LL.n) * invr;

cosp = cos(ph);
sinp = sin(ph);

BX = (Br*sint + Bth*cost)*cosp - Bph*sinp;
By = (Br*sint + Bth*cost)*sinp + Bph*cosp;
BZ =  Br*cost - Bth*sint;

Bx =  BX*cosP + BZ*sinP;
Bz = -BX*sinP + BZ*cosP;

end

function Ps = l_Ps(P, sinmu)

if abs(sinmu) < 1e-4
    Ps = 0;
else
    Ps = P/sinmu;
end

end
