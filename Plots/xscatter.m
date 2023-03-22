function xscatter(x, y, ms, m, mf, me)

if ~exist('ms', 'var')
    ms = 3;
end
ms = ms^2;
if ~exist('m', 'var')
    m = 'o';
end
if ~exist('mf', 'var')
    mf = 'b';
end
if ~exist('me', 'var')
    me = mf;
end

xx = reshape(x, [1 numel(x)]);
yy = reshape(y, [1 numel(y)]);

figure;
scatter(xx, yy, ms, 'Marker', m, 'MarkerFaceColor', mf, 'MarkerEdgeColor', me); hold on
set(gca, 'DataAspectRatio', [1 1 1]) 

end
