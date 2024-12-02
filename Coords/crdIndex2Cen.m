function cen = crdIndex2Cen(naxis, cdelt, crval, crpix)

cen = crdPix2Arc((naxis+1)/2, cdelt, crval, crpix);

end
