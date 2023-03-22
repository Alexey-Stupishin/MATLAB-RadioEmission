function [xm, ir, ic] = xmin2(B)

if nargout > 2
    [m, i] = min(B);
    [xm, ic] = min(m);
    ir = i(ic);
else
    xm = min(min(B));
end

end
