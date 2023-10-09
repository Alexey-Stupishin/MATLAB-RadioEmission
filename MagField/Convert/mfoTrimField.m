function [B, index] = mfoTrimField(Bany, xrange, yrange, zrange, index)

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
    cdelt2 = index.cdelt2*(xrange(2)-xrange(1));
    cdelt1 = index.cdelt1*(yrange(2)-yrange(1));
    crpix2 = (1+length(xrange))/2;
    crpix1 = (1+length(yrange))/2;
    crval2 = index.crval2 - (index.crpix2-xrange(1))*index.cdelt2 + (crpix2-1)*cdelt2;
    crval1 = index.crval1 - (index.crpix1-yrange(1))*index.cdelt1 + (crpix1-1)*cdelt1;
    
    index.naxis1 = length(yrange);
    index.naxis2 = length(xrange);
    index.cdelt1 = cdelt1;
    index.cdelt2 = cdelt2;
    index.crval1 = crval1;
    index.crval2 = crval2;
    index.crpix1 = crpix1;
    index.crpix2 = crpix2;
else
    index = [];
end

end

%--------------------------------------------------------------------------
function comp = l_trim(B0, scomp, xrange, yrange, zrange)

comp = [];
if isfield(B0, scomp)
    comp = B0.(scomp)(xrange, yrange, zrange);
end

end
