function cb = ssuShowQuiv4(hAx, hAx_x, hAx_y, isQuiv, B3, level, lineStep, lineWidth, lineLength, lineColor, isbar)

if ~exist('level', 'var') || isempty(level)
    level = 1;
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

B3 = fpuField2XYZ(B3);

[~, cb] = ssuImage(hAx, B3.z(:, :, level), scale, offset, [], true, isbar);
hold(hAx, 'on')

if (isQuiv)
    ssuQuiver(hAx, B3.x(:, :, level), B3.y(:, :, level), lineColor, lineStep, scale, offset, lineWidth, lineLength);
end

if ~isempty(hAx_x)
    ssuImage(hAx_x, B3.x(:, :, level), scale, offset, [], true, isbar);
end

if ~isempty(hAx_y)
    ssuImage(hAx_y, B3.y(:, :, level), scale, offset, [], true, isbar);
end

end
