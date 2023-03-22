function Bmax = asu_getMaxBbySST(filename)

d = iouSAV2Data(filename);
BB = fpuFieldVal(d.MFODATA);
n = size(BB,3);
Bmax = zeros(1, n);
f2 = zeros(1, n);
f3 = zeros(1, n);
for k = 1:n
    Bmax(k) = xmax2(BB(:,:,k));
end

f2 = 2*reuLarmourFreq(Bmax)*1e-9;
f3 = 3*reuLarmourFreq(Bmax)*1e-9;

h = (0:n-1)*d.MFODATA.DKM/1000;

h2 = xplot(h, f2, 'Color', 'r');
h3 = plot(h, f3, 'Color', 'b');
ssuPictForPublic(gca, '', 20, [], 'Height, Mm', 'Frequency, GHz');
set(gca, 'XLim', [0 3], 'YLim', [3 18]);
legend([h2 h3], {'2nd harm', '3rd harm'});

end
