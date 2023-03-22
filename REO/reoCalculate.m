function [depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd, ...
          depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt, ...
          pScanOrd, pScanExt] = ...
         reoCalculate(hLib, H, Temp, Dens, freq, harms, pTauL, Mask, needScans, mode, c, b, posR, posL, limits)

if exist('Mask', 'var') && ~isempty(Mask)
    Mask = int32(Mask);
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

[depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd, ...
 depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt, ...
 pScanOrd, pScanExt, ...
] = gstCalcMapAll(hLib, ...
                     H, Temp, Dens, ...
                     Mask, ...
                     freq, harms, pTauL, ...
                     needScans, ...
                     mode, c, b, posR-1, posL-1, limits);

%                   rc, ...
%  pTimes, pQuanc82Cnt, pLaplas90Cnt, pLaplasCnt ...

% if any(any(rc))
%     disp('***** Some problems during calculation *****');
% end

end
