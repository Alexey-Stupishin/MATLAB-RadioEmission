function m = mfmCalcMetrics(B, m)

global gWIV

m.Bx = B.x;
m.By = B.y;
m.Bz = B.z;
[Babs, m.inclination, m.azimuth, m.B_transv] = fpuFieldVal(B);

% [Jx, Jy, Jz] = curl(permute(B.y, [2 1 3]), permute(B.x, [2 1 3]), permute(B.z, [2 1 3]));
% m.Jx = permute(Jy, [2 1 3]);
% m.Jy = permute(Jx, [2 1 3]);
% m.Jz = permute(Jz, [2 1 3]);

curlEx4pr2(B.x, B.y, B.z);
m.Jx = gWIV.C43(:,:,:,1);
m.Jy = gWIV.C43(:,:,:,2);
m.Jz = gWIV.C43(:,:,:,3);

J.x = m.Jx;
J.y = m.Jy;
J.z = m.Jz;
m.J = fpuFieldVal(J);
m.JxB_angle = l_JxB_angle(B, J, Babs, m.J);
m.divB = divergence(B.x, B.y, B.z)/6./Babs;

end

%--------------------------------------------------------------------------
function angle = l_JxB_angle(B, J, Babs, Jabs)
    J.x = J.x./Jabs;
    J.y = J.y./Jabs;
    J.z = J.z./Jabs;
    B.x = B.x./Babs;
    B.y = B.y./Babs;
    B.z = B.z./Babs;
    v = l_getVectorProd(J, B);
    vs = sqrt(v.x.^2 + v.y.^2 + v.z.^2);
    vs(vs > 1) = 1;
    vs(vs < -1) = -1;
    angle = asind(vs);
end

%--------------------------------------------------------------------------
function v = l_getVectorProd(J, B)

v.x = J.z.*B.y - J.y.*B.z;
v.y = J.x.*B.z - J.z.*B.x;
v.z = J.y.*B.x - J.x.*B.y;

end
