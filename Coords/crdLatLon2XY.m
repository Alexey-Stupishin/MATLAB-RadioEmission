function [x, y, z] = crdLatLon2XY(lat, long)
% lat, long - as in Solar observations (visible!)
% x - vertical, y - horizontal

% Spherical -> Cartesian
x = sind(lat);
y = cosd(lat).*sind(long);
z = cosd(lat).*cosd(long);

end
