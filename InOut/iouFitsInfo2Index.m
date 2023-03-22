function index = iouFitsInfo2Index(keys)

index.NAXIS1 = iouFitsGetKey(keys, 'NAXIS1');
index.CRPIX1 = iouFitsGetKey(keys, 'CRPIX1');
index.CRVAL1 = iouFitsGetKey(keys, 'CRVAL1');
index.CDELT1 = iouFitsGetKey(keys, 'CDELT1');
index.NAXIS2 = iouFitsGetKey(keys, 'NAXIS2');
index.CRPIX2 = iouFitsGetKey(keys, 'CRPIX2');
index.CRVAL2 = iouFitsGetKey(keys, 'CRVAL2');
index.CDELT2 = iouFitsGetKey(keys, 'CDELT2');

end
