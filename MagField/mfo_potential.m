function [BX, BY, BZ] = mfo_potential(Blos, Nz, vcos, coefs)

if ~exist('vcos', 'var')
    vcos = [0 0 1];
end

if ~exist('coefs', 'var')
    coefs = [0.5 0.5];
end

tic
[BX, BY, BZ] = mfrLFFF3DXYZ(Blos, vcos, Nz, coefs, 0, false, false);
toc

end
