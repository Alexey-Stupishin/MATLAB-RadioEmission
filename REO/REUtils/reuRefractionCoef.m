function [n2, u, v, st2, ct2] = reuRefractionCoef(B, N, theta, f)

u = (reuLarmourFreq(B)./f).^2;
v = (reuPlasmaFreq(N)./f).^2;

st2 = sind(theta)^2;
ct2 = cosd(theta)^2;

mv = 1-v;

ust2 = u*st2;
uct2 = u*ct2;

sqD = sqrt(ust2.^2 + 4*uct2.*mv.^2);
n2 = zeros(2, length(sqD));
modes = [-1, 1];
for k = 1:2
    mode = modes(k);
    n2(k, :) = 1-(2*v.*mv)./(2*mv - ust2 + mode.*sqD);
end

end
