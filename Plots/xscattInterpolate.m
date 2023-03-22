function res = xscattInterpolate(X, Y, data, method, extrap)

if ~exist('method', 'var')
    method = 'linear';
end
if ~exist('extrap', 'var')
    extrap = 'nearest';
end

res = scatteredInterpolant(reshape(X, [numel(X) 1]), reshape(Y, [numel(Y) 1]), reshape(data, [numel(data) 1]), method, extrap);

end
