function [rotmap, hmlim, vmlim, rotindex] = crdFitsRotate(map, index, angle, scale, outval)

if ~exist('scale', 'var')
    scale = 1;
end
if ~exist('outval', 'var')
    outval = 0;
end

instep = [index.CDELT1 index.CDELT2];
outstep = scale*instep;

[rotmap, hmlim, vmlim, hcrnew, vcrnew] = crdPlaneMapRotate(map, instep, angle, outstep, index.CRPIX1, index.CRPIX2, index.CRVAL1, index.CRVAL2, outval);

rotindex.NAXIS1 = size(rotmap, 2);
rotindex.NAXIS2 = size(rotmap, 1);
rotindex.CDELT1 = outstep(1);
rotindex.CDELT2 = outstep(2);
rotindex.CRPIX1 = hcrnew;
rotindex.CRPIX2 = vcrnew;
rotindex.CRVAL1 = 0;
rotindex.CRVAL2 = 0;

end
