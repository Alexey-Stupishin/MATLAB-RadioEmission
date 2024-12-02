function [xa, fa] = asm_golden_sect_lim(func, tol, lim)
% find maximum!

iphi = 2/(sqrt(5)+1);

x0 = lim(1);
x1 = lim(2);
f0 = feval(func, x0);
f1 = feval(func, x1);

dphi = (x1-x0)*iphi;
xa = x1 - dphi;
xb = x0 + dphi;
fa = feval(func, xa);
fb = feval(func, xb);

while abs(xa-xb) > tol
    if fa < fb
        x0 = xa;
        xa = xb;
        fa = fb;
        xb = x0 + (x1-x0)*iphi;
        fb = feval(func, xb);
    else
        x1 = xb;
        xb = xa;
        fb = fa;
        xa = x1 - (x1-x0)*iphi;
        fa = feval(func, xa);
    end
end

end
