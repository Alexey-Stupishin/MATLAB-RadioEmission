function vcos = crdVCos(lat, lon)

vcos(1) = -cosd(lon)*sind(lat);
vcos(2) = -sind(lon);
vcos(3) =  cosd(lon)*cosd(lat);

end
