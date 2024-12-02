function [map, lowers, uppers] = colormapAsymmAddMark(lims, nsteps, plus, minus, center, zero, contrast, addMark, addMark2)

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

lowers = 0;
uppers = 0;
map = colormapAsymm(lims, nsteps, plus, minus, center, zero, contrast);
if exist('addMark', 'var') && ~isempty(addMark)
    map = [addMark; map];
    lowers = size(addMark, 1);
end
if exist('addMark2', 'var') && ~isempty(addMark2)
    map = [map; addMark2];
    uppers = size(addMark2, 1);
end

end
