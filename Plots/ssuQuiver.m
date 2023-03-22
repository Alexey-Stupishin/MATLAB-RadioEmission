function ssuQuiver(hAx, Bx, By, color, plainStep, scale, offset, lineWidth, lineLength)

if (~exist('plainStep', 'var'))
    plainStep = 1;
end
if (~exist('scale', 'var'))
    scale = [1 1];
end
if (~exist('offset', 'var'))
    offset = [0 0];
end
if (~exist('lineWidth', 'var'))
    lineWidth = 1;
end
if (~exist('lineLength', 'var'))
    lineLength = 0.8;
end

if (all(all(Bx == 0)) && all(all(By == 0)))
    return
end

Bxex = zeros(size(Bx));
Bxex(1:plainStep:size(Bx, 1), 1:plainStep:size(Bx, 2)) = Bx(1:plainStep:size(Bx, 1), 1:plainStep:size(Bx, 2));
Byex = zeros(size(By));
Byex(1:plainStep:size(By, 1), 1:plainStep:size(By, 2)) = By(1:plainStep:size(By, 1), 1:plainStep:size(By, 2));
quiver(hAx, (0:size(By, 2)-1)*scale(2)+offset(2), (0:size(By, 1)-1)*scale(1)+offset(1), Byex, Bxex, ...
            'AutoScale', 'on', 'AutoScaleFactor', lineLength*plainStep, 'Color', color, 'LineWidth', lineWidth);
set(hAx,'DataAspectRatio',[1,1,1]);

end
