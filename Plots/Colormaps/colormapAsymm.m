function map = colormapAsymm(lims, nsteps, plus, minus, center, zero, contrast)

if ~exist('nsteps', 'var') || isempty(nsteps)
    nsteps = 231;
end;
if ~exist('plus', 'var') || isempty(plus)
    plus = [0 0 1];
end
if ~exist('minus', 'var') || isempty(minus)
    minus = [1 0 0];
end
if ~exist('center', 'var') || isempty(center)
    center = [0.9 0.9 0.9];
end
if ~exist('zero', 'var') || isempty(zero)
    zero = [1 1 1];
end
if ~exist('contrast', 'var') || isempty(contrast)
    contrast = 1;
end

assert(length(lims) > 1);
assert(lims(2) >= lims(1));

if lims(2) == lims(1)
    map(1, :) = zero;
    return
end

vzero = 0;
if length(lims) > 2
    vzero = lims(3);
end
rel = (vzero - lims(1))/(lims(2) - lims(1));
n2 = round(rel*(nsteps-1) + 1);
mm = min(max(0, n2-1), nsteps);
pp = nsteps-mm;
hh = max(mm, pp);

mult = ((0:hh)/hh).^contrast;
multmap = repmat(mult', 1, 3);

map = zeros(nsteps, 3);

dminus = (center - minus);
minusmap = repmat(dminus, hh+1, 1);
matm = minusmap .* multmap + repmat(minus, hh+1, 1);
if mm > 0
    map(1:mm, :) = matm(end-mm+1:end, :);
    map(mm+1, :) = zero;
end

dplus = (center - plus);
plusmap = repmat(dplus, hh+1, 1);
matp = plusmap .* flip(multmap, 1) + repmat(plus, hh+1, 1);
if pp > 0
    map(end-pp+2:end, :) = matp(1:pp-1, :);
    map(end-pp+1, :) = zero;
end

end
