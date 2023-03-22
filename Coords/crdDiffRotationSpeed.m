function ddeg = crdDiffRotationSpeed(lat) % degrees/day
% lat in degrees
% NB! ToDo: sources?

diffWc0 = 14.35;
diffWc2 = -2.77;
diffWc4 = -0.9856;

sinphi = sind(abs(lat));
s2 = sinphi.^2;

ddeg = diffWc0 + s2.*(diffWc2 + s2*diffWc4);

end
