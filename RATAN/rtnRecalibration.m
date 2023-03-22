function [ratan, im] = rtnRecalibration(ratan, f_recal, d_recal)

for k = 1:length(ratan.Freqs)
    vm = mean(ratan.Freqs(k).I([1:10 end-9:end]));
    f.I = f.I - vm;
end
dpix = ratan.SOLAR_R/ratan.Freqs(k).XSCALE*d_recal;
from = floor(ratan.Freqs(k).crpix - dpix);
to = ceil(ratan.Freqs(k).crpix + dpix);

[~, ifreq] = min(abs(f_recal - [ratan.Freqs.freq]));
[~, im] = min(ratan.Freqs(ifreq).I(from:to));
im = im + from - 1;
for k = 1:length(ratan.Freqs)
    corr = ratan.Freqs(k).tqsun*ratan.Freqs(k).kflux;
    ratan.Freqs(k).I = ratan.Freqs(k).I/ratan.Freqs(k).I(im)* corr;
    ratan.Freqs(k).I(isnan(ratan.Freqs(k).I)) = 0;
    ratan.Freqs(k).V = ratan.Freqs(k).V/ratan.Freqs(k).V(im)* corr;
    ratan.Freqs(k).V(isnan(ratan.Freqs(k).V)) = 0;
end
    
end
