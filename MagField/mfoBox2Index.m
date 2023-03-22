function index = mfoBox2Index(box)
% NOTE: everything are transposed!

index = box;
sz = size(box.BZ);

index.CDELT1 = box.DY_ARC;
index.NAXIS1 = sz(2);
index.CRVAL1 = 0;
index.CRPIX1 = - box.Y_CEN*box.R_ARC/index.CDELT1 + (index.NAXIS1-1)/2;
index.CDELT2 = box.DX_ARC;
index.NAXIS2 = sz(1);
index.CRVAL2 = 0;
index.CRPIX2 = - box.X_CEN*box.R_ARC/index.CDELT2 + (index.NAXIS2-1)/2;

end
