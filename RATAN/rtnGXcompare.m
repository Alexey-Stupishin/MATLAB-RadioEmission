function [freqs, maxMod, cposMM, maxRat, cposMR, scansTM, scansTR] = rtnGXcompare(model, scans, spectra, mode)

% assert() % length freqs

if ~exist('mode', 'var')
    mode = 'I';
end

dsearch = 10;

frfr = zeros(1, length(scans.freqs));
for kf = 1:length(frfr)
    [~, im] = min(abs(scans.freqs(kf) - spectra.freqs));
    frfr(kf) = spectra.ff(im);
end

posangle = scans.header.RATAN_P;
dxr = scans.header.CDELT1;

par = model.PARAMETERS;
instep = [par.DX par.DY];

if strcmp(mode, 'I')
    scRI = scans.right + scans.left;
elseif strcmp(mode, 'R')
    scRI = scans.right;
else
    scRI = scans.left;
end

freqs = zeros(1, length(model.DATA));
scansTR = zeros(length(model.DATA), size(scRI, 1));
scansTM = [];
maxMod = [];
maxRat = [];
cposMM = [];
cposMR = [];
for kf = 1:length(model.DATA)
    freqs(kf) = l_parseId(model.DATA{kf}.ID) * 1e9;
    scanR = scRI(:,kf)';
    scansTR(kf, :) = scanR;
    
    M = model.DATA{kf}.I;
    mult = 2;
    if ~strcmp(mode, 'I')
        mult = 1;
        V = model.DATA{kf}.V;
        if ~strcmp(mode, 'R')
            M = M - V;
        else
            M = M + V;
        end
    end

    xbase = par.XC - par.DX*(size(M,1)-1)/2;
    ybase = par.YC - par.DY*(size(M,2)-1)/2;
    [M, xmlim, ~] = crdPlaneMapRotate(M, instep, -posangle, dxr, xbase, ybase);
    
    fI = reuTemp2Flux(M, dxr, freqs(kf)) * mult;

    [dH, dV] =  mfoCreateRATANDiagrams(freqs(kf), size(fI), dxr, xmlim, 3);
    [scanM, ~] = gstMapConv(fI, dH, dV, dxr);
    if isempty(scansTM)
        scansTM = zeros(length(model.DATA), size(scanM, 2));
    end
    
    Ifrfr = mult*frfr(kf);
    scanM(scanM < max(scanM)*0.01) = NaN;
    scanM = scanM + Ifrfr;
    scansTM(kf, :) = scanM;
    
    if isempty(maxRat)
        [maxMod, cposMM] = max(scanM);
        maxMod = maxMod - Ifrfr;
        [maxRat, cposMR] = max(scanR);
        maxRat = maxRat - Ifrfr;
    else
        avposMM = round(sum(cposMM)/length(cposMM));
        [mM, imM] = max(scanM(avposMM-dsearch:avposMM+dsearch));
        mM = mM - Ifrfr;
        maxMod = [maxMod mM];
        cposMM = [cposMM imM+avposMM-dsearch+1];
        avposMR = round(sum(cposMR)/length(cposMR));
        [mR, imR] = max(scanR(avposMR-dsearch:avposMR+dsearch));
        mR = mR - Ifrfr;
        maxRat = [maxRat mR];
        cposMR = [cposMR imR+avposMR-dsearch+1];
    end
end

end

%--------------------------------------------------------------------------
function freq = l_parseId(id)

outs = regexp(id, 'GX ([0-9+-.]*).*', 'tokens');
freq = str2double(outs{1}{1});

end
