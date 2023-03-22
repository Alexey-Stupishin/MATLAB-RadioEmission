function [a, b, dx, yass] = asmHyperbRiseApprox(x0, y0, x1, y1, x2, y2, deriv, b0, d0)

if ~exist('b0', 'var') || isempty(b0)
    b0 = 0.3;
end
if ~exist('d0', 'var') || isempty(d0)
    d0 = 0.5;
end

initsimp = [ ...
             b0, d0; ...
             b0-0.1, d0+0.1; ...
             b0+0.1, d0-0.1; ...
           ];

x = NelderMead(@l_calc, @l_crit, @l_bound, initsimp, 1, 2, 0.5, 0.5);

    function x = l_bound(x)
        x(1) = max(x(1), 1e-7);
        x(2) = max(x(2), 1e-7);
    end

    function f = l_calc(x)
        f = l_metrics(x1, x0, y1, y0, deriv, x(2), x(1)) + l_metrics(x2, x0, y2, y0, deriv, x(2), x(1));
    end

    function conv = l_crit(x, ~)
        conv = std(x(:, 1), 0, 1)/mean(x(:, 1), 1) < 1e-3 && all(std(x(:, 2:end), 0, 1) < 1e-3);
    end

b = x(1);
dx = x(2);

a = b/deriv/dx^(b+1);
yass = y0+1/a/dx^b;

end

function m = l_metrics(xi, x0, yi, y0, deriv, dx, b)

m = (dx^(b+1)*deriv/b*(1/(xi-x0+dx)^b-1/dx^b) - y0 + yi)^2;

end
