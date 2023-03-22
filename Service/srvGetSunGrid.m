function [xc1, yc1, xc2, yc2] = srvGetSunGrid()

half = (-90:90)/180*pi;
mult = ones(size(half))/180*pi;
range = -90:10:90;
xc1 = zeros(length(range), length(half));
yc1 = zeros(length(range), length(half));
xc2 = zeros(length(range), length(half));
yc2 = zeros(length(range), length(half));
for k = 1:length(range)
    [xc1(k,:), yc1(k,:)] = crdVisSphere2PictPlane(half, range(k)*mult);
    % line(yc1(k,:), xc1(k,:), 'Color', 'k', 'LineStyle', '-'); hold on
    [xc2(k,:), yc2(k,:)] = crdVisSphere2PictPlane(range(k)*mult, half);
    % line(yc2(k,:), xc2(k,:), 'Color', 'k', 'LineStyle', '-'); hold on
end

end
