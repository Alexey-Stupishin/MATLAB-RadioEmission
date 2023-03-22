function [latn, lonn] = crdRotateBySolarB(lat, lon, B)
% everythings in degrees !
% B > 0: South pole turns behind the disk, North pole - visible (in autumn)
% B < 0: North pole turns behind the disk, South pole - visible (in spring)
% visible coordinates -> real (helio) coordinates: crdRotateSolarB(lat, lon, +B)
% real (helio) coordinates -> visible coordinates: crdRotateSolarB(lat, lon, -B)

sinlat = sind(lat)*cosd(B) + cosd(lat).*cosd(lon)*sind(B);
coslatsinlon = cosd(lat).*sind(lon);

latn = asind(sinlat);
lonn = asind(coslatsinlon./cosd(latn));

% latn = lat;
% lonn = lon;
% 
% 
% s = (abs(lon) < 1e-6);
%     
% latn(s) = lat(s) + B;
% lonn(s) = lon(s);
% 
% sinlat = sind(lat(~s))*cosd(B) + cosd(lat(~s)).*cosd(lon(~s))*sind(B);
% coslatsinlon = cosd(lat(~s)).*sind(lon(~s));
% % coslatcoslon = -sind(lat(~s))*sind(B) + cosd(lat(~s)).*cosd(lon(~s))*cosd(B);
% 
% latn(~s) = asind(sinlat);
% lonn(~s) = asind(coslatsinlon./latn(~s));

% lonn(~s) = atand(sind(lon(~s))./(cosd(B)*cosd(lon(~s)) - sind(B)*tan(lat(~s))));
% nosign = ~s & (sign(lonn) ~= sign(lon));
% lonn(nosign) = lonn(nosign) + sign(lon(nosign))*180;
% latn(~s) = asind(cosd(B)*sind(lat(~s)) + sind(B)*cosd(lat(~s)).*cosd(lon(~s)));

end
