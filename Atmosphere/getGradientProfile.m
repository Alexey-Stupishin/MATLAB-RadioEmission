function T = getGradientProfile(h, T0, h0, A, xc, w)

if ~exist('h0', 'var')
    h0 = 0;
end
if ~exist('A', 'var')
    A = 1.50166;
end
if ~exist('xc', 'var')
    xc = 1.78286e8;
end
if ~exist('w', 'var')
    w = 0.00148 * 1e8;
end

y = l_Lorentz(h*1e-8, h0*1e-8, A*1e8, xc*1e-8, w*1e-8);
T = cumsum(y(1:end-1).*diff(h)) + T0;
T = [T T(end)];

end

function y = l_Lorentz(x, h0, A, xc, w)

y = h0+2*A/pi * w ./ (4*(x-xc).^2 + w^2);

end
