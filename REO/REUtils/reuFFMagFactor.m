function [n2, F] = reuFFMagFactor(B, N, theta, f)

[n2, u, v, st2, ct2] = reuRefractionCoef(B, N, theta, f);
mv = 1-v;
ust2 = u*st2;
uct2 = u*ct2;

sqD = sqrt(ust2.^2 + 4*uct2.*mv.^2);
num1 = ust2+2*mv.^2;
num2 = ust2.^2;
den1 = 2*mv - ust2;
F = zeros(2, length(sqD));
modes = [-1, 1];
for k = 1:2
    mode = modes(k);
    msqD = mode*sqD;
    F(k, :) = 2*(msqD.*num1 - num2)./(msqD.*(den1+msqD).^2);
end

F = F./sqrt(n2);

end
