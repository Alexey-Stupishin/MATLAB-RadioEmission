function [hAx, lims, cb, hIm] = xssuImage(imdata, scale, offset, cmapdata, nodatascale, isbar, alpha)

if (~exist('scale', 'var'))
    scale = [1 1];
end
if length(scale) == 1
    scale = [scale scale];
end
if (~exist('offset', 'var'))
    offset = [0 0];
end
if (~exist('cmapdata', 'var'))
    cmapdata = [];
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

figure;
hAx = gca;
[lims, cb, hIm] = ssuImage(hAx, double(imdata), scale, offset, cmapdata, nodatascale, isbar, alpha);

end
