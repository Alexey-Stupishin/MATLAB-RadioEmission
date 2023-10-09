function [B, modstep, Ra] = getModel1Dipole(nx, ny, nz, arcstep, B0ph, depth)

Rr = 6.96e10;
Ra = 960;

modstep = arcstep/Ra;

D = depth/Rr/modstep;

posy = (ny - 1)*0.5 + 1;

posx = 0.5*(nx - 1) + 1;

mu = l_getMu(B0ph, D);

tic

B.x = zeros(nx, ny, nz);
B.y = zeros(nx, ny, nz);
B.z = zeros(nx, ny, nz);
for k = 1:nz
    [~, ~, B0] = getDipole(nx, ny, posx, posy, D+k-1, mu);
    B.x(:, :, k) = B0.x;
    B.y(:, :, k) = B0.y;
    B.z(:, :, k) = B0.z;
end

toc

BBm = fpuFieldVal(B);
xsurf(BBm(:,:,1));
xmax2(BBm(:,:,end))

end

function mu = l_getMu(B, D)

mu = 0.5*B*D^3;

end
