function [B, index_out] = mfoTrimField(Bany, xrange, yrange, zrange, index)

if isfield(Bany, 'absB')
    B0 = Bany;
else
    B0 = fpuField2XYZ(Bany);
end

if ~exist('zrange', 'var') || isempty(zrange)
    zrange = 1;
end

comp = l_trim(B0, 'x', xrange, yrange, zrange); if ~isempty(comp), B.x = comp; end
comp = l_trim(B0, 'y', xrange, yrange, zrange); if ~isempty(comp), B.y = comp; end
comp = l_trim(B0, 'z', xrange, yrange, zrange); if ~isempty(comp), B.z = comp; end
comp = l_trim(B0, 'absB', xrange, yrange, zrange); if ~isempty(comp), B.absB = comp; end
comp = l_trim(B0, 'incl', xrange, yrange, zrange); if ~isempty(comp), B.incl = comp; end
comp = l_trim(B0, 'azim', xrange, yrange, zrange); if ~isempty(comp), B.azim = comp; end

if exist('index', 'var')
    cdelt2 = index.CDELT2*(xrange(2)-xrange(1));
    cdelt1 = index.CDELT1*(yrange(2)-yrange(1));
    crpix2 = (1+length(xrange))/2;
    crpix1 = (1+length(yrange))/2;
    crval2 = index.CRVAL2 - (index.CRPIX2-xrange(1))*index.CDELT2 + (crpix2-1)*cdelt2;
    crval1 = index.CRVAL1 - (index.CRPIX1-yrange(1))*index.CDELT1 + (crpix1-1)*cdelt1;
    
    index_out.NAXIS1 = length(yrange);
    index_out.NAXIS2 = length(xrange);
    index_out.CDELT1 = cdelt1;
    index_out.CDELT2 = cdelt2;
    index_out.CRVAL1 = crval1;
    index_out.CRVAL2 = crval2;
    index_out.CRPIX1 = crpix1;
    index_out.CRPIX2 = crpix2;
    
    index_out.XSCALE = index_out.CDELT1;
    index_out.YSCALE = index_out.CDELT2;

    index_out.XCEN = crdIndex2Cen(index_out.NAXIS1, cdelt1, crval1, crpix1);
    index_out.YCEN = crdIndex2Cen(index_out.NAXIS2, cdelt2, crval2, crpix2);
else
    index_out = [];
end

end

%--------------------------------------------------------------------------
function comp = l_trim(B0, scomp, xrange, yrange, zrange)

comp = [];
if isfield(B0, scomp)
    comp = B0.(scomp)(xrange, yrange, zrange);
end

end
