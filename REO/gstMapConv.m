function [scan, flux] = gstMapConv(rmap, diagr, diagrV, arcstep, mode)
% diagrW in arcsec
% map in FLUXES!

if length(arcstep) == 1
    arcstep = [arcstep arcstep];
end

if ~exist('mode', 'var')
    mode = 'full';
end

rmap(isnan(rmap)) = 0;
rmap = rmap .* repmat(diagrV', 1, size(rmap, 2));
Iint = sum(rmap, 1);
scan = conv(Iint', diagr', mode)' / arcstep(2);

flux = sum(scan)*arcstep(2);

end
