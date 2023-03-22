function [xm, ir, ic] = xmax2(B)

if nargout > 2
    [m, i] = max(B);
    [xm, ic] = max(m);
    ir = i(ic);
else
    xm = max(max(B));
end

end
