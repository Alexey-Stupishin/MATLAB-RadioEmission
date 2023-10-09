function [scans, arcsecs, T, flux, fluxNS] = reuQuietSun(freqs, R, step, dmode, mmode, c, b, vshift)
% for one polarization!

if ~exist('dmode', 'var') || isempty(dmode)
    dmode = 3;
end
if ~exist('mmode', 'var') || isempty(mmode)
    mmode = 1;
end
if ~exist('c', 'var') || isempty(c)
    c = 0.009;
end
if ~exist('b', 'var') || isempty(b)
    b = 8.338;
end
if ~exist('vshift', 'var') || isempty(vshift)
    vshift = 0;
end

RE = R*1.3;

Nv = 2*ceil(RE/step)+1;
%Nh = 2*Nv+1;
Nh = 3*Nv;

if mmode == 1
    dT = ones(1, length(freqs));
    dRR = ones(1, length(freqs));
    dRP = ones(1, length(freqs));
else
    dT = 0.91654 + 0.05271*3e10./freqs;
    dRR = 1.00525 + 0.01105*3e10./freqs;
    dRP = 0.7*ones(1, length(freqs));
end
dP = ones(1, length(freqs));

scans = zeros(length(freqs), Nh);
basev = -RE;
arcsecs = linspace(3*basev, -3*basev, Nh);
[dH, dV] =  mfoCreateRATANDiagrams(freqs, [Nv, Nv], step, basev, dmode, c, b);
if vshift ~= 0
    v = floor(vshift/step);
    dVex = zeros(size(dV));
    Nv = length(dV);
    dVex(:, max(1,1+v):min(Nv,Nv+v)) = dV(:, max(1,1-v):min(Nv,Nv-v));
    dV = dVex;
end

T = QS_Temp_Zirin_et_al_1991(freqs);
% T = QS_Temp_Center_Borovik_1997(freqs);

% figure;
flux = zeros(1, length(freqs));
fluxNS = zeros(1, length(freqs));
for kf = 1:length(freqs)
    rmap = reuCircleMap(Nv, Nh, R/step, dRR(kf), dRP(kf), dT(kf), dP(kf));
    fluxmap = rmap; %reuTemp2Flux(rmap*T(kf), step, freqs(kf));
    fluxNS(kf) = xsum2(fluxmap);
    [scan, flux(kf)] = gstMapConv(fluxmap, dH(kf,:), dV(kf,:), step, 'same');
    scans(kf, :) = scan;
    % plot(arcsecs, scans(kf, :)); hold on
    % plot(rmap(floor(size(rmap,1)/2), :)); hold on
end

% lw = 2;
% ff = max(scans, [], 2);
% d = iouSAV2Data('s:\University\Work\Flocculae\spectr_shablon.sav');
% hZ = xplot(freqs*1e-9, ff, 'LineWidth', lw);
% hS = plot(d.WORK_FREQS_SHABL', squeeze(d.SMOO_X1)*1e-4, 'LineWidth', lw);
% ssuPictForPublic(gca, 'Quiet Sun (Borovik) in the Disk Center', 20, [], 'Frequency, GHz', 'Flux, s.f.u./arcsec');
% legend([hZ hS], {'Zirin+RATAN', '"shablon"'});

% wing = 10;

% figure;
% plot(arcsecs, scan); hold on
% fid = fopen('c:\temp\qs.dat', 'w');
% for k = Nv-wing+1:2*Nv+1+wing
%     fprintf(fid, '%d %e', k, (k-Nv-(Nv-1)/2)*step/R);
%     for kf = 1:length(freqs)
%         fprintf(fid, ' %e', scans(kf, k));
%     end
%     fprintf(fid, '\r\n');
% end
% fclose(fid);

end
