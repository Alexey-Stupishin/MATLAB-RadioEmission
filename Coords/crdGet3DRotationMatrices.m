function [VAR2VCS, VCS2VAR, vcos] = crdGet3DRotationMatrices(lat, lon)
% lat, lon - as in Solar observations (visible!)
% vertical in AR-system [0;0;1] -> VAR2VCS*[0;0;1] in observer system
% vertical in observer system [0;0;1] -> VCS2VAR*[0;0;1] in AR-system

sinlat = sind(lat);
coslat = cosd(lat);
sinlon = sind(lon);
coslon = cosd(lon);

VAR2VCS = [ 
            coslat,              0,        sinlat; ...
           -sinlat*sinlon   coslon, coslat*sinlon; ...
           -sinlat*coslon, -sinlon, coslat*coslon; ...
          ];
VCS2VAR = VAR2VCS^-1;             

vcos = crdVCos(lat, lon);

end
