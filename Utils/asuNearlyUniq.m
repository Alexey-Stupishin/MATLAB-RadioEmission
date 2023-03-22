function v = asuNearlyUniq(v, tol)

if length(v) < 2
    return 
end

if ~exist('tol', 'var')
    tol = 1e-3;
end

v = unique(v);

v(diff(v(:))/max(abs(v)) <= tol) = [];
    
end 