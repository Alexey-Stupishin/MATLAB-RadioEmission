function map = colormapRainbow(contrast, inverse, n, bottom, top, nbottom, ntop)

map = hsv(256);

if ~exist('n', 'var') || isempty(n)
    n = 175; % excluding magenta; 205 - including magenta
end

map(n:end, :) = [];

if exist('inverse', 'var') && inverse
    map = map(end:-1:1, :);
end

if exist('bottom', 'var') && length(bottom) >= 3
    if ~exist('nbottom', 'var') || isempty(nbottom)
        nbottom = 10;
    end
    mb = [linspace(bottom(1), map(1, 1), nbottom)' linspace(bottom(2), map(1, 2), nbottom)' linspace(bottom(3), map(1, 3), nbottom)'];
    map = [mb(1:end-1, :); map];
end

if exist('top', 'var') && length(top) >= 3
    if ~exist('ntop', 'var') || isempty(ntop)
        ntop = 10;
    end
    mb = [linspace(map(end, 1), top(1), ntop)' linspace(map(end, 2), top(2), ntop)' linspace(map(end, 3), top(3), ntop)'];
    map = [map; mb(2:end, :)];
end

if ~exist('contrast', 'var')
    contrast = 1;
end

if contrast ~= 1
    map = ssucApplyContrast(map, contrast);
end

end
