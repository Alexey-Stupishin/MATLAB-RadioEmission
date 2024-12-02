function [to, m] = mfoTrimSize2Depth(sz, from, step, to_depth)

if ~exist('from', 'var')
    from = 1;
end

if ~exist('step', 'var')
    step = 1;
end

if ~exist('to_depth', 'var')
    to_depth = [25 2];
end

if length(to_depth) == 2
    to_depth = mfoMatryoskaDepth(sz, to_depth(1), to_depth(2));
end

m = 2^(to_depth-1) * step;
d = floor((sz-1)/m);
to = from + d*m;

end
