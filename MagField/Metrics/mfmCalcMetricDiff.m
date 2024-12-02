function [M_angle, M_res] = mfmCalcMetricDiff(B, B2)

M_res = sqrt((B.x-B2.x).^2 + (B.y-B2.y).^2 + (B.z-B2.z).^2);
BB = fpuFieldVal(B);
BB2 = fpuFieldVal(B2);
dot = (B.x.*B2.x + B.y.*B2.y + B.z.*B2.z)./BB./BB2;
dot(dot > 1) = 1;
dot(dot < -1) = -1;
M_angle = acosd(dot);

end

