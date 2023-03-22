function showRATANonSUN(fname, azimuth)

fname = 'g:\BIGData\UCache\HMI\2016-12-21\hmi.M_720s.20161221_091200_TAI.magnetogram.fits';
f1700 = 'g:\BIGData\UCache\HMI\2016-12-21\aia.lev1_uv_24s.2016-12-21T091148Z.image.1700.fits';
rname = 'g:\BIGData\RATAN\2016\12\21\20161221_121151_sun+0_out.fits';
azimuth = 0;

rects = struct('x', [-250, -160], 'y', [-110, -30]);
rects = [rects struct('x', [120, 230], 'y', [225, 325])];
rects = [rects struct('x', [190, 360], 'y', [30, 150])];
rects = [rects struct('x', [340, 800], 'y', [50, 300])];

src = iouLoadFitsSDO(fname);
aia1700 = iouLoadFitsSDO(f1700);

ratan = iouLoadFitsRATAN(rname);
% [solar_p, solar_b, solar_r, sol_dec] = asuGetSolarPar(astAnyDateTimeJD(src.DATE_OBS));
posangle = rtnGetPositionAngle(ratan.AZIMUTH, ratan.SOL_DEC, ratan.SOLAR_P);

cmapdata.cmap = colormapAsymm([min(min(src.image)) max(max(src.image))], [], [], [], [], [], 8);
cmapdata.nodatascale = true;
cmapdata.centered = false;
cmapdata.nandata = 0;

l_draw(src.image, posangle, src, cmapdata, 0, @l_replaceHMI, ratan, 20, rects);

cm1700 = colormapAIA('1700');
cm1700.nodatascale = false;
cm1700.centered = false;
aiaim = aia1700.image;
aiaim(aiaim > 3000) = 3000;

l_draw(aiaim, posangle, aia1700, cm1700, 3000, [], ratan, 20, rects);

end

%--------------------------------------------------------------------------
function cmapdata = l_replaceHMI(cmapdata, map)
    cmapdata.cmap = colormapAsymm([min(min(map)) max(max(map))], [], [], [], [], [], 8);
end

%--------------------------------------------------------------------------
function l_draw(inmap, posangle, src, cmapdata, outdata, cmreplacefun, ratan, freq, rects)

for v = 1:size(inmap, 2)
    for h = 1:size(inmap, 1)
        dv = (v - src.CRPIX2)*src.CDELT2;
        dh = (h - src.CRPIX1)*src.CDELT1;
        if (dv^2 + dh^2) > (src.RSUN_OBS-10)^2
            inmap(v, h) = outdata;
        end
    end
end

xssuImage(inmap, [1 1], [0 0], cmapdata, true);

instep = [src.CDELT1 src.CDELT2];
outstep = instep*5;

rlim = 1000;
outcol = 10;

[outmap, ~, ~, out] = crdFitsRotate(inmap, src, posangle, 5, outcol);

out.SOLAR_R = src.SOLAR_R;

if ~isempty(cmreplacefun)
    cmapdata = cmreplacefun(cmapdata, outmap);
end
xssuImage(outmap, outstep, [-out.CRPIX1*out.CDELT1 -out.CRPIX2*out.CDELT2], cmapdata, true, false);

ratf = ratan.Freqs(freq);
n = length(ratf.I);
xpoints = ((1:n)-1 - n/2)*ratf.XSCALE + ratf.XCEN;
idx = find(xpoints < -rlim);
rrx(1) = max(idx);
idx = find(xpoints > rlim);
rrx(2) = min(idx);
xpoints = xpoints(rrx(1):rrx(2));

hold on

I = ratf.I(rrx(1):rrx(2));
V = ratf.V(rrx(1):rrx(2));
R = (I+V)/2;
L = I-R;
ratmin = min([R L]);
ratmax = max([R L]);
RR = (R-ratmin)/(ratmax-ratmin)*2*rlim - rlim;
LL = (L-ratmin)/(ratmax-ratmin)*2*rlim - rlim;
hold on; plot(xpoints, RR);
hold on; plot(xpoints, LL);
% V = ratf.V(rrx(1):rrx(2))./I;
% ratmax = max(abs(V));
% VV = V*5*rlim;
% ratmax = max(abs(V));
% VV = V/ratmax*rlim;
% hold on; plot(xpoints, VV);

% plot([xpoints(1) xpoints(end)], [0 0]);
% plot([xpoints(1) xpoints(end)], -0.5*[1 1]*rlim);
% plot([xpoints(1) xpoints(end)], 0.5*[1 1]*rlim);

ssuPictForPublic(gca, '', 20);

for k = 1:length(rects)
    l_draw_rect(rects(k).x, rects(k).y, posangle);
end

end

%--------------------------------------------------------------------------
function l_draw_rect(x, y, angle)

lw = 1;
col = 'k';

x = x + [-10 10];
y = y + [-10 10];

sp = sind(angle);
cp = cosd(angle);

xm = zeros(2, 2);
ym = zeros(2, 2);

for kx = 1:2
    for ky = 1:2
        xm(kx, ky) = - y(ky)*sp + x(kx)*cp;
        ym(kx, ky) =   y(ky)*cp + x(kx)*sp;
    end
end

str = sprintf('%7.2f\t%7.2f\t%7.2f\t%7.2f\t%7.2f\t%7.2f\t%7.2f\t%7.2f', xm(1,1), ym(1,1), xm(1,2), ym(1,2), xm(2,2), ym(2,2), xm(2,1), ym(2,1));
disp(str)

plot([xm(1,1) xm(1,2)], [ym(1,1) ym(1,2)], 'Color', col, 'LineWidth', lw);
plot([xm(1,2) xm(2,2)], [ym(1,2) ym(2,2)], 'Color', col, 'LineWidth', lw);
plot([xm(2,2) xm(2,1)], [ym(2,2) ym(2,1)], 'Color', col, 'LineWidth', lw);
plot([xm(2,1) xm(1,1)], [ym(2,1) ym(1,1)], 'Color', col, 'LineWidth', lw);

end
