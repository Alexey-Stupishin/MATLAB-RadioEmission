function [map, exlims] = colormapRundiff(lims, nsteps, nodiff, diff, extra, contrast)

if ~exist('nsteps', 'var') || isempty(nsteps)
    nsteps = 231;
end;
if ~exist('nodiff', 'var') || isempty(nodiff)
    nodiff = [1 1 1];
end
if ~exist('diff', 'var') || isempty(diff)
    diff = [0 0 0];
end
if ~exist('extra', 'var') || isempty(extra)
    extra = [1 0 0];
end
if ~exist('contrast', 'var') || isempty(contrast)
    contrast = 1;
end

assert(length(lims) > 1);
assert(lims(2) >= lims(1));

if lims(2) == lims(1)
    map(1, :) = [0 0 0];
    return
end

vzero = 0;
if length(lims) > 2
    vzero = lims(3);
end

step = (lims(2) - lims(1))/(nsteps-3);
lims(2) = lims(2) + step;
exlims = lims(1:2);

rel = (vzero - lims(1))/(lims(2) - lims(1));
n2 = round(rel*(nsteps-1) + 1);
mm = min(max(0, n2-1), nsteps);
pp = nsteps-mm;
hh = max(mm, pp);

mult = ((0:hh)/hh).^contrast;
multmap = repmat(mult', 1, 3);

map = zeros(nsteps, 3);

dcol = (nodiff - diff);

minusmap = repmat(dcol, hh+1, 1);
matm = minusmap .* multmap + repmat(diff, hh+1, 1);
if mm > 0
    map(1:mm, :) = matm(end-mm+1:end, :);
    map(mm+1, :) = nodiff;
end

plusmap = repmat(dcol, hh+1, 1);
matp = plusmap .* flip(multmap, 1) + repmat(diff, hh+1, 1);
if pp > 0
    map(end-pp+2:end, :) = matp(1:pp-1, :);
    map(end-pp+1, :) = nodiff;
end

map(end, :) = extra;

end
