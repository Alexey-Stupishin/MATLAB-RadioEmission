function [Bc, transv] = fpuMEField2XYZ(B, useAbm)
% B - observed field in B.ME (Milne-Eddington, MERLIN) form (B.absB, B.incl, B. azim)
% Bc - field in B.CC (Cartesian coordinates) form (B.x, B.y, B.z)

if (~exist('useAbm', 'var'))
    useAbm = 0;
end
azim = B.azim;

if (useAbm == 1)
    ann = (B.disambig == 2 | B.disambig == 3 | B.disambig == 6 | B.disambig == 7);
    azim(ann) = azim(ann) + 180;
elseif (useAbm == 2)
    azim(B.SFQ > 0) = azim(B.SFQ > 0) + 180;
end

Bc.z =   B.absB .* cosd(B.incl);
transv = B.absB .* sind(B.incl);
Bc.x =   transv .* cosd(azim);
Bc.y =   transv .* sind(azim);

end
