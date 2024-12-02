function pix = crdArc2Pix(arc, cdelt, crval, crpix)

pix = (arc - crval)/cdelt + crpix;

end
