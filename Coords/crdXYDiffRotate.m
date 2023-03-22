function [xrot, yrot] = crdXYDiffRotate(from, to, xarc, yarc)

tf = astAnyDateTime(from);
tfrom = datenum(tf);
tto = datenum(astAnyDateTime(to));
dt = tto - tfrom; % days

[~, solar_b, solar_r] = asuGetSolarPar(juliandate(datetime(tf.Year, tf.Month, tf.Day, tf.Hour, tf.Minute, tf.Second)));
[lat, lon] = crdXY2LatLon(yarc/solar_r, xarc/solar_r);
[latn, lonn] = crdRotateBySolarB(lat, lon, solar_b);
ddeg = crdDiffRotationSpeed(latn); % degrees/day
lond = lonn + dt*ddeg;
[latr, lonr] = crdRotateBySolarB(latn, lond, -solar_b);
[yr, xr] = crdLatLon2XY(latr, lonr);
xrot = xr*solar_r;
yrot = yr*solar_r;

end