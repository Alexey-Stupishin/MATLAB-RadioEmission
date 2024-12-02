function arc = crdPix2Arc(pix, cdelt, crval, crpix)

arc = (pix - crpix)*cdelt + crval;

end
