function [MM, base, Bc] = reoSetField(hLib, mfoData, gridstep, Min, basein)

if ~exist('gridstep', 'var') || isempty(gridstep)
    gridstep = [1 1];
end
    
gstSetPreferenceDouble(hLib, 'cycloMap.Conditions.RSun', mfoData.R);

gridstepinR = gridstep/mfoData.R;
M = size(mfoData.B.z);
if exist('Min', 'var') && exist('basein', 'var')
    [MoutInt, base] = gstCalcSetField(hLib, ...
                      M, M, mfoData.B.x, mfoData.B.y, mfoData.B.z, mfoData.vcos, mfoData.stepP, mfoData.baseP, gridstepinR, mfoData.posangle, Min, basein);
else
    [MoutInt, base] = gstCalcSetField(hLib, ...
                      M, M, mfoData.B.x, mfoData.B.y, mfoData.B.z, mfoData.vcos, mfoData.stepP, mfoData.baseP, gridstepinR, mfoData.posangle);
end
base = base*mfoData.R; 
MM = double(MoutInt);

% sz = size(mfoData.B.x);
% ratio = mfoData.stepP(1)/gridstepinR(1);
% Pz = ceil(ratio*sz(3));
% Pzest = max(sz(1:2))*0.7*ratio;
% MM3 = [MM ceil(min(Pz, Pzest))];

[Bc.x, Bc.y, Bc.z] = gstCalcGetField(hLib);

end
