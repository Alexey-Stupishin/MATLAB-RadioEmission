function [B, transv, Bz] = fpuXYZField2ME(Bc, index)
% Bc - field in B.CC (Cartesian coordinates) form (B.x, B.y, B.z) or B4 form (index should exist or default 1)
% B - observed field in B.ME (Milne-Eddington, MERLIN) form (B.absB, B.incl, B.azim)
% NOTE: B.azim is true (-180...180)

if (~isstruct(Bc)) % suppose B4
    if (~exist('index', 'var'))
        index = 1;
    end
    B4 = Bc;
    clear Bc
    Bc.x = B4(:, :, index, 1);
    Bc.y = B4(:, :, index, 2);
    Bc.z = B4(:, :, index, 3);
    clear B4
elseif isfield(Bc, 'BZ')
    Bc.x = Bc.BX;
    Bc.y = Bc.BY;
    Bc.z = Bc.BZ;
end

transv = sqrt(Bc.x.^2 + Bc.y.^2);
Bz = Bc.z;
B.absB = sqrt(transv.^2 + Bc.z.^2);
B.incl = acosd(Bc.z./B.absB);
B.azim = atan2d(Bc.y, Bc.x);
% B.azim(B.azim < 0) = B.azim(B.azim < 0) + 180;

end
