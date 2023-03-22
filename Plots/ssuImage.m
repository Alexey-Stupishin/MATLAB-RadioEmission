function [lims, cb, hIm] = ssuImage(hAx, imdata, scale, offset, cmapdata, nodatascale, isbar, alpha)

if (~exist('scale', 'var'))
    scale = [1 1];
end
if length(scale) == 1
    scale = [scale scale];
end
if (~exist('offset', 'var'))
    offset = [0 0];
end
if ~exist('nodatascale', 'var')
    nodatascale = false;
end
if ~exist('isbar', 'var')
    isbar = true;
end
if ~exist('alpha', 'var')
    alpha = 1;
end

cb = [];

imrange = [min(min(imdata)) max(max(imdata))];

mainMapSize = 231;
centered = false;
nandata = mainMapSize;
if (~exist('cmapdata', 'var') || isempty(cmapdata))
    cmap = colormapAsymm(imrange);
    nodatascale = true;
    centered = false;
    nandata = 0;
    
%     cmap = ssuSymmColormap(mainMapSize);
%     centered = true;
%     nandata = 115;
else
    cmap = cmapdata.cmap;
    if (isfield(cmapdata, 'centered'))
        centered = cmapdata.centered;
    end
    if (isfield(cmapdata, 'nandata'))
        nandata = cmapdata.nandata;
    end
end

absmax = max(max(abs(imdata)));
if ~nodatascale
    if (centered)
        imdata = (imdata/absmax + 1)/2*mainMapSize;
    else
        imdata = (imdata+absmax)/(2*absmax)*mainMapSize;
    end
    imdata(isnan(imdata)) = nandata;
    if (centered)
        imdata(1, 1) = 0;
        imdata(end, end) = mainMapSize;
    end
else
    if (centered)
        imdata(1, 1) = -absmax;
        imdata(end, end) = absmax;
    end
end
imdata(isnan(imdata)) = nandata;

lims = [xmin2(imdata) xmax2(imdata)];

% axes(hAx);
hIm = image(hAx, (0:size(imdata, 2)-1)*scale(2) + offset(2), (0:size(imdata, 1)-1)*scale(1) + offset(1), ...
    imdata, 'CDataMapping','scaled', 'AlphaDataMapping','none', 'AlphaData',alpha);
% if ~isempty(alpha)
%     %alphamap = alpha*ones(size(imdata, 2), size(imdata, 1));
%     set(hIm, 'AlphaDataMapping','none', 'AlphaData',alpha);
% end
set(hAx, 'YDir','normal', 'Layer', 'top');
%set(hAx, 'XLim', [0 size(imdata, 2)-1]*scale(2)+offset(2), 'YLim', [0 size(imdata, 1)-1]*scale(1)+offset(1));

set(hAx, 'DataAspectRatio', [1,1,1]);
colormap(hAx, cmap)

if isbar
%    cb = colorbar(hAx, 'Location', 'northoutside', 'Limits', imrange);
    cb = colorbar(hAx, 'Location', 'eastoutside');
end

end
