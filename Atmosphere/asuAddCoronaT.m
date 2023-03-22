function [HH, logTT, a, b, dx, yass] = asuAddCoronaT(H, logT, dx1, fact_y1, dx2, y2, stepMm, maxHMm)

HMm = H*1e-8;

x0 = HMm(end);
y0 = logT(end);
deriv = (logT(end-1) - logT(end))/(HMm(end-1) - HMm(end));
deriv = min([deriv 60]);

x1 = x0+dx1;
y1 = fact_y1*y2;

x2 = x0+dx2;

[a, b, dx, yass] = asmHyperbRiseApprox(x0, y0, x1, y1, x2, y2, deriv);

n = floor((maxHMm - x0)/stepMm);
v = x0 + (1:n)*stepMm;
y = l_hyp(v, x0, yass, dx, a, b);

HH = [HMm; v']*1e8;
logTT = [logT; y'];

end

function y = l_hyp(x, x0, yass, dx, a, b)

y = yass - 1/a./(x-x0+dx).^b;

end
