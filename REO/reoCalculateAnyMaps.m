function reoCalculateAnyMaps

libname = 's:\Projects\Physics104_291\ProgramD64\agsGeneralRadioEmission.dll';

%mfoData = mfoLoadField('s:\Projects\IDL\ASlibrary\Samples\12470_hmi.M_720s.20151218_125809.W86N13CR.CEA.NAS_1000.sav');
mfoData = mfoLoadField('s:\Projects\IDL\ASlibrary\Samples\12470_hmi.M_720s.20151218_112209.W85N13CR.CEA.NAS_1000_sst.sav');
 
%mfoData = mfoLoadField('s:\UData\12673\NLFFF\12673_hmi.M_720s.20170905_091042.W118S8CR.CEA.NAS.sav');
%mfoData = mfoLoadField('d:\UData\11520\SA_v5\AS03_hmi.M_720s.20120712_045826.W82S16CR.CEA.NAS_sst.sav');

%mfoData = mfoLoadField('g:\BIGData\UData\SDOBoxes_HMI\11520_hmi.M_720s.20120712_093426.W83S15CR.CEA.NAS_700_sst.sav'); 
[solar_p, ~, ~, sol_dec] = asuGetSolarPar(astAnyDateTimeJD(mfoData.time));
mfoData.posangle = rtnGetPositionAngle(10, sol_dec, solar_p);
%mfoData.posangle = 0;

QT = 1;
freefree = 0;

freqs = 16.3e9;
nf = 1;
step = 1;
% atm.H = [1   1e8 1.1e8 1.9e8 5.0e8 3.0e10];
% atm.T = [1e4 1e4 2.5e6 2.8e6 4.0e6 4.0e6];
atm.H = [1   1e8 1.1e8 1.9e8 5.0e8 3.0e10];
atm.T = [1e4 1e4 3.0e6 3.0e6 3.0e6 3.0e6];
atm.D = 0.7e15./atm.T;
atm.mask = [];

[~, ~, rescalc, ~, base] = reoCalcModelSpectraIndep(libname, QT, freefree, mfoData, freqs, atm, step);

flux = rescalc(nf).fluxR;
scan = rescalc(nf).scanR;

xlim = [-400 -240];
ylim = [-150 70];

% % magn = mfoData.magnetogram_src;
% % cont = mfoData.continuum_src;
% % sz = size(magn.DATA);
% % x(1) = magn.YC - sz(2)*magn.DY/2;
% % x(2) = magn.YC + sz(2)*magn.DY/2;
% % y(1) = magn.XC - sz(1)*magn.DX/2;
% % y(2) = magn.XC + sz(1)*magn.DX/2;
% % 
% % xpm = round((xlim - x(1))/magn.DY);
% % ypm = round((ylim - y(1))/magn.DX);

% data = magn.DATA';
% data = data(xpm(1):xpm(2), ypm(1):ypm(2));
% 
% figure;
% ssuImage(gca, data, [magn.DY magn.DX], [xlim(1) ylim(1)])
% ssuPictForPublic(gca, 'Magnetogram', 24);
% c = colorbar;
% c.Label.String = 'B_z, G';
% 
% data = cont.DATA';
% data = data(xpm(1):xpm(2), ypm(1):ypm(2));
% 
% figure;
% ssuImage(gca, data, [cont.DY cont.DX], [xlim(1) ylim(1)])
% colormap(gca, 'gray')
% ssuPictForPublic(gca, 'Continuum', 24);
% c = colorbar;
% c.Label.String = 'Intensity, ---';

posx = round((xlim - base(1))/step)+1;
posy = round((ylim - base(2))/step)+1;
flux = flux(posx(1):posx(2), posy(1):posy(2));

% figure;
% ssuImage(gca, flux, [step step], [xlim(1) ylim(1)])
% set(gca, 'DataAspectRatio', [1 1 1])
% Fm = xsum2(flux);
% ssuPictForPublic(gca, ['Radio map, total flux = ' num2str(Fm, '%4.2f') ' s.f.u'], 24);
% c = colorbar;
% c.Label.String = 'Intensity, s.f.u./arcsec^2';
% 
% [row, m] = getGaussNorm(5, 16, 31);
% V = repmat(row, [31 1]);
% H = repmat(row', [1 31]);
% D = V.*H;
% D = D/xsum2(D);
% figure;
% ssuImage(gca, D)
% set(gca, 'DataAspectRatio', [1 1 1])
% ssuPictForPublic(gca, 'Beam', 64);
% c = colorbar;
% c.Label.String = 'arcsec^{-2}';
% 
% [diagr.H, diagr.V] =  mfoCreateRATANDiagrams(freqs, size(flux), [step step], [xlim(1) ylim(1)], 3);
% 
% r = conv2(flux, D, 'same');
% figure;
% ssuImage(gca, r, [step step], [xlim(1) ylim(1)])
% set(gca, 'DataAspectRatio', [1 1 1])
% Fc = xsum2(r);
% ssuPictForPublic(gca, ['Convolution, total flux = ' num2str(Fc, '%4.2f') ' s.f.u'], 24);
% c = colorbar;
% c.Label.String = 'Intensity, s.f.u./arcsec^2';
% 
% rm = flux .* repmat(diagr.V(nf, :)', [1, size(flux, 2)]);
% 
arcs = ylim(1) + (0:size(flux,2)-1)*step;
varcs = xlim(1) + (0:size(flux,1)-1)*step;
% 
% tscan = sum(rm, 1);
% xplot(arcs, tscan, 'LineWidth', 3);
% ssuPictForPublic(gca, 'Non-convolved scan', 24, [], 'arcsec', 's.f.u./arcsec');
% 
% xplot(varcs, diagr.V(nf, :), 'LineWidth', 3, 'Color', 'r')
% ssuPictForPublic(gca, 'V-Beam', 24, [], 'arcsec', 'dimensionless');
% xplot(diagr.H(nf, :), 'LineWidth', 3, 'Color', 'r')
% set(gca, 'XLim', [250 400]);
% ssuPictForPublic(gca, 'S-Beam', 24, [], 'arcsec', 'arcsec^{-1}');

xplot(arcs, scan(posy(1):posy(2)), 'LineWidth', 3)
ssuPictForPublic(gca, 'Scan', 24, [], 'arcsec', 's.f.u./arcsec');

ratan = iouLoadRATANData('s:\University\Work\11520\RATAN\v20.520_2\RATAN_AR11520_20120712_083609_az+10_SCANS__flocculae-included_stille_appr.dat');
plot(ratan.pos, ratan.right(:, 5))
set(gca, 'XLim', [arcs(1) arcs(end)]);

end
