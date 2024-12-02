function [T, Y] = getLowLouP(n, lambda, nsteps)

  function dydx = mat4ode(x, y)
  % Derivative function. q is provided by the outer function.
    if abs(1-x^2) < 1e-7 && x < 0
        v = -1/(1-x)*(f1 + lambda*f2*(deriv0*(1+x))^(2/n))*deriv0;
    elseif abs(1-x^2) < eps
        v = 0;
    else
        v = -1/(1-x^2)*(f1 + lambda*f2*y(1)^(2/n))*y(1);
    end
    dydx = [ y(2)
             v ];
  end

deriv0 = 10;

f1 = n*(n+1);
f2 = (n+1)/n;

if exist('nsteps', 'var') && ~isempty(nsteps)
    t = linspace(-1, 1, nsteps);
else
    t = [-1 1];
end
options = odeset('RelTol',1e-7,'AbsTol',1e-10);
[T, Y] = ode45(@mat4ode, t, [0 deriv0], options);

end
