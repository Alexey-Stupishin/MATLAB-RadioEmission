function [hAx, cb] = ssuShowQuiv4(B3, level, bshow, name, lineStep, lineWidth, lineLength, lineColor, isbar)

if ~exist('level', 'var') || isempty(level)
    level = 1;
end
if ~exist('bshow', 'var') || isempty(bshow)
    bshow = [1 0 0];
end
if ~exist('name', 'var') || isempty(name)
    name = '';
end
if ~exist('lineStep', 'var') || isempty(lineStep)
    lineStep = 1;
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
scale = [1 1];
offset = [0 0];

if ~isstruct(B3)
    B3 = fpuB4toXYZ3D(B3);
end

hFig = figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['Bz ' name]);
hAx = gca;
[~, cb] = ssuImage(hAx, B3.z(:, :, level), scale, offset, [], true, isbar);
hold on

if (bshow(1))
    ssuQuiver(hAx, B3.x(:, :, level), B3.y(:, :, level), lineColor, lineStep, scale, offset, lineWidth, lineLength);
end

if (bshow(2))
    hFig = figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['Bx ' name]);
    hAx = gca;
    ssuImage(hAx, B3.x(:, :, level), scale, offset, [], true, isbar);
end

if (bshow(3))
    hFig = figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', ['By ' name]);
    hAx = gca;
    ssuImage(hAx, B3.y(:, :, level), scale, offset, [], true, isbar);
end

end
