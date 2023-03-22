function cmap = colormapAIACore(wave)

if ~exist('wave', 'var')
    wave = 171;
end

aiaMap = iouSAV2Data(['s:\Projects\Matlab\Plots\Colormaps\aiaMaps\aia' num2str(wave) '.sav']);

cmap = zeros(length(aiaMap.RED), 3);
cmap(:, 1) = double(aiaMap.RED)/256;
cmap(:, 2) = double(aiaMap.GREEN)/256;
cmap(:, 3) = double(aiaMap.BLUE)/256;
cmap = cmap.^0.45;
    
end
