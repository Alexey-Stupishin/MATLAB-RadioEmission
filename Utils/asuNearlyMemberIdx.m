function idx = asuNearlyMemberIdx(test, in, tol)

if ~exist('tol', 'var')
    tol = 1e-3;
end

idx = [];
for k = 1:length(in)
    i = find(abs(test-in(k))/max(abs(in)) <= tol, 1);
    if ~isempty(i)
        idx = [idx k]; %#ok
    end
end

end
