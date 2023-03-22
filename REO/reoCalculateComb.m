function [depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd, ...
          depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt, ...
          pScanOrd, pScanExt] = ...
         reoCalculateComb(hLib, H, Temp, Dens, freq, harms, pTauL, Mask, needFF, needScans, mode, c, b, posR, posL, limits)

if exist('Mask', 'var') && ~isempty(Mask)
    Mask = double(Mask);
else
    Mask = [];
end
if ~exist('needScans', 'var')
    needScans = false;
end
if ~exist('mode', 'var')
    mode = 3;
end
if ~exist('c', 'var') || isempty(c)
    c = 0;
end
if ~exist('b', 'var') || isempty(b)
    b = 8.5;
end
if ~exist('posR', 'var')
    posR = 0;
end
if ~exist('posL', 'var')
    posL = 0;
end
if ~exist('limits', 'var')
    limits = [];
end

gstSetAtmosphere(hLib, H, Temp, Dens);

[depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd, ...
 depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt, ...
 pScanOrd, pScanExt, ...
] = gstCalcMapByAtm(hLib, ...
                     Mask, ...
                     freq, harms, pTauL, ...
                     needScans, ...
                     mode, c, b, posR-1, posL-1, limits);

end
