function [grid1, grid2] = iouFitsHeader2Grid(index)

grid1 = (-index.CRPIX1 + (0:index.NAXIS1-1))*index.CDELT1 + index.CRVAL1;
grid2 = (-index.CRPIX2 + (0:index.NAXIS2-1))*index.CDELT2 + index.CRVAL2;

end
