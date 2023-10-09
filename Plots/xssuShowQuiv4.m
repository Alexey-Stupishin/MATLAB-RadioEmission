function [hAx, cb] = xssuShowQuiv4(B3, level, bshow, lineStep, name, lineWidth, lineLength, lineColor, isbar)

B3 = fpuField2XYZ(B3);

if ~exist('name', 'var') || isempty(name)
    name = '';
end

figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['Bz ' name]);
hAx = gca;
hAx_x = [];
hAx_y = [];

if ~exist('level', 'var') || isempty(level)
    level = 1;
end
if ~exist('bshow', 'var') || isempty(bshow)
    bshow = [1 1 1];
end
if ~exist('lineStep', 'var') || isempty(lineStep)
    sz = size(B3.x);
    lineStep = floor(sqrt(sz(1)*sz(2))/100);
end
if ~exist('lineWidth', 'var') || isempty(lineWidth)
    lineWidth = 1;
end
if ~exist('lineLength', 'var') || isempty(lineLength)
    lineLength = 0.8;
end
if ~exist('lineColor', 'var') || isempty(lineColor)
    lineColor = [0 1 0];
end
if ~exist('isbar', 'var') || isempty(isbar)
    isbar = true;
end

isQuiv = bshow(1);
if bshow(2)
    figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['Bx ' name]);
    hAx_x = gca;
end
if bshow(3)
    figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['By ' name]);
    hAx_y = gca;
end

cb = ssuShowQuiv4(hAx, hAx_x, hAx_y, isQuiv, B3, level, lineStep, lineWidth, lineLength, lineColor, isbar);

end
