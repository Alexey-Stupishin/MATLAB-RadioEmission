function [crpix, crval] = crdCen2Index(naxis, cdelt, cen)

crpix = (naxis+1)/2;
crval = crdPix2Arc((naxis+1)/2, cdelt, cen, crpix);

end
