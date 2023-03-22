function testColors

%cm = colormapRainbow(1, true, [], [1 1 1], [], 50, 50);
%cm = colormapRainbow(1, true, [], [0 0 0], [], 10, 50);
%cm = colormapRainbow();
%cm = colormapRainbowT(1, [], [], [1 1 1]);

cm = colormapIronHeat();

%--------------------------------------------------------------------------
p = abs(peaks);
p = l_scale(p, size(cm, 1));

figure
surf(p)
colormap(cm)
colorbar

end

%--------------------------------------------------------------------------
function p = l_scale(p, n)

pmin = xmin2(p);
pmax = xmax2(p);
p = (p - pmin)/(pmax - pmin)*(n-2) + 0.5;

end
