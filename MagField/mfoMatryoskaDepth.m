function depth = mfoMatryoskaDepth(sz, minsize, factor)

if ~exist('minsize', 'var')
    minsize = 25;
end
if ~exist('factor', 'var')
    factor = 2;
end
if length(sz) == 1
    sz = [sz sz];
end

minN = min(sz(1:2));
sfactor = minN/minsize;
depth = ceil(log(sfactor)/log(factor));

end
