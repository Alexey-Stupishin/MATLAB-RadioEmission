function map = colormapRainbowTI(contrast, n, bottom, top, nbottom, ntop)

if ~exist('n', 'var') || isempty(n)
    n = 175; % excluding magenta; 205 - including magenta
end

if ~exist('bottom', 'var') || length(bottom) < 3
    bottom = [0 0 0];
end
if ~exist('nbottom', 'var') || isempty(nbottom)
    nbottom = 5;
end

if ~exist('top', 'var') || length(top) < 3
    top = [];
end
if ~exist('ntop', 'var') || isempty(ntop)
    ntop = 10;
end
if ~exist('contrast', 'var')
    contrast = 1;
end

map = colormapRainbow(contrast, true, n, bottom, top, nbottom, ntop);

end
