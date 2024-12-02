function [T, Y, lambda] = getLowLouPN(n, nlambda, nsteps)

if ~exist('nsteps', 'var')
    nsteps = [];
end

% n = 1:
assert(n == 1)
lambdas = [0 4.2740839e-01 2.54324e+00 8.76005e+00 2.28683e+01 5.02353e+01 9.79814e+01 1.75140e+02];

lambda = lambdas(nlambda+1);
[T, Y] = getLowLouP(n, lambda, nsteps);

end
