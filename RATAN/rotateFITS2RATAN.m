function [rotated, source, ratan] = rotateFITS2RATAN(fitsfile, ratanfile)

source = iouLoadFitsSDO(fitsfile);
ratan = iouLoadFitsRATAN(ratanfile);
% [solar_p, solar_b, solar_r, sol_dec] = asuGetSolarPar(astAnyDateTimeJD(source.DATE_OBS));
posangle = rtnGetPositionAngle(ratan.AZIMUTH, ratan.SOL_DEC, ratan.SOLAR_P);

source.image(source.image > 2000) = 0;
tic
[rotimage, ~, ~, rotindex] = crdFitsRotate(source.image, source, posangle);
toc

rotated = source;
rotated.RAT_DATE = ratan.OBS_DATE;
rotated.RAT_TIME = [ratan.OBS_TIME 'Z'];
rotated.RAT_DOBS = [rotated.RAT_DATE 'T' rotated.RAT_TIME];
rotated.AZIMUTH = ratan.AZIMUTH;
rotated.ALTITUDE = ratan.ALTITUDE;
rotated.SOL_RA = ratan.SOL_RA;
rotated.SOLAR_P = ratan.SOLAR_P;
rotated.SOLAR_B = ratan.SOLAR_B;
rotated.ROT_ANGL = posangle;

left = floor(rotindex.CRPIX1 - (source.NAXIS1+1)/2);
right = left + source.NAXIS1 - 1;
down = floor(rotindex.CRPIX2 - (source.NAXIS2+1)/2);
up = down + source.NAXIS2 - 1;
rotated.image = rotimage(down:up, left:right);

rotated.NAXIS1 = size(rotated.image, 2);
rotated.NAXIS2 = size(rotated.image, 1);
rotated.CDELT1 = rotindex.CDELT1;
rotated.CDELT2 = rotindex.CDELT2;
rotated.CRPIX1 = rotindex.CRPIX1 - left;
rotated.CRPIX2 = rotindex.CRPIX2 - down;
rotated.XCEN = (- rotated.CRPIX1 + (rotated.NAXIS1+1)/2) * rotated.CDELT1 + rotated.CRVAL1;
rotated.YCEN = (- rotated.CRPIX2 + (rotated.NAXIS2+1)/2) * rotated.CDELT2 + rotated.CRVAL2;

end
