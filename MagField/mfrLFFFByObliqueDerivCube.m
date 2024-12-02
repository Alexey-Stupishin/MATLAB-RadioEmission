function [Bx, By, Bz] = mfrLFFFByObliqueDerivCube(Bl_base, vcos, Nz, expCoefs)

sz = size(Bl_base);
Bx = zeros(sz(1), sz(2), Nz); 
By = zeros(sz(1), sz(2), Nz); 
Bz = zeros(sz(1), sz(2), Nz); 
for k = 1:Nz 
    %Bout = mfrLFFFByObliqueDeriv_prev(Bl_base, vcos, k-1, expCoefs);
    Bout = mfrLFFFByObliqueDeriv(Bl_base, vcos, k-1, expCoefs);
    Bx(:,:,k) = Bout.x;
    By(:,:,k) = Bout.y;
    Bz(:,:,k) = Bout.z;
end

end
