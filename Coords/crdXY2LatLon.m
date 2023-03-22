function [lat, long, dist] = crdXY2LatLon(x, y)
% x - vertical, y - horizontal
% lat, long - as in Solar observations (visible!)

% Cartesian -> Spherical
lat = asind(x);
coslat = sqrt(1-x.*x);
long = asind(y./coslat);
dist = acosd(y./coslat);

end
