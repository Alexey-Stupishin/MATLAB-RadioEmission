function LowLouSpherical(n, nlambda, d, Phi, nx, ny, nz, lat0, dlat, lon0, dlon, fname)

%s:\UData\LowLou1\Base\LowLou_1_10000.dat 
Bphmax = 2500;

if ~exist('fname', 'var') || isempty(fname)
    [T, Y, lambda] = getLowLouPN(n, nlambda, 1000);
else
    [T, Y, lambda] = getLowLouPNFromFile(fname, n, nlambda);
end
LL.n = n;
LL.a = sqrt(lambda);
LL.mus = T;
LL.PPd = Y;

grid = l_grid(d, lat0, dlat, lon0, dlon, nx, ny, nz);

B.x = zeros(grid.nx, grid.ny, grid.nz);
B.y = zeros(grid.nx, grid.ny, grid.nz);
B.z = zeros(grid.nx, grid.ny, grid.nz);
for kx = 1:grid.nx
    for ky = 1:grid.ny
        for kz = 1:grid.nz
            [B.x(kx, ky, kz), B.y(kx, ky, kz), B.z(kx, ky, kz)] = getLowLouFieldInPoint(LL, grid.dLL, Phi, [grid.x(kx, ky, kz) grid.y(kx, ky, kz) grid.z(kx, ky, kz)]);
        end
    end
    disp(['kx=' num2str(kx) ', ' num2str(kx/grid.nx*100) '%'])
end

Bs.lat = zeros(grid.nx, grid.ny, grid.nz);
Bs.lon = zeros(grid.nx, grid.ny, grid.nz);
Bs.r = zeros(grid.nx, grid.ny, grid.nz);
for kx = 1:grid.nx
    for ky = 1:grid.ny
        for kz = 1:grid.nz
            [VAR2VCS, VCS2VAR] = crdGetPictPlane2PhsphPlaneTrans(grid.ps(kx, ky, kz), grid.ls(kx, ky, kz));
            v(1) = B.x(kx, ky, kz);
            v(2) = B.y(kx, ky, kz);
            v(3) = B.z(kx, ky, kz);
            vt = VAR2VCS*v';
            Bs.lat(kx, ky, kz) = vt(1);
            Bs.lon(kx, ky, kz) = vt(2);
            Bs.r(kx, ky, kz) = vt(3);
        end
    end
    disp(['kx=' num2str(kx) ', ' num2str(kx/grid.nx*100) '%'])
end

BB = fpuFieldVal(B);
BBmax = max(max(max(BB)));

B.x = B.x/BBmax*Bphmax;
B.y = B.y/BBmax*Bphmax;
B.z = B.z/BBmax*Bphmax;
xssuShowQuiv4(B, 1, [1 0 0], [], 1, 1, 1.2, [0 0 0], false);

Bs.lat = Bs.lat/BBmax*Bphmax;
Bs.lon = Bs.lon/BBmax*Bphmax;
Bs.r = Bs.r/BBmax*Bphmax;

BLAT = Bs.lat;
BLON = Bs.lon;
BR = Bs.r;
LAT = (lat0 + (0:nx-1)*dlat);
LON = (lon0 + (0:ny-1)*dlon);
R = 1 + (0:nz-1)*dlat/180*pi;
BX = B.x;
BY = B.y;
BZ = B.z;
GR = grid.r;
GTH = grid.t;
GPH = grid.p;
PARN = LL.n;
PARNLAM = nlambda;
PARD = grid.dLL;
PARLATC = grid.latc;
PARLONC = grid.lonc;

path = fileparts(fname);
foutname = fullfile(path, ['LowLou_Spherical' num2str(LL.n) '_' num2str(nlambda) '_' num2str(d) '_' num2str(Phi) '_' num2str(nx) '_' num2str(lon0) '_' num2str(lat0) '.bin']);

iouData2SAV(foutname, 'BLAT', 'BLON', 'BR', 'LAT', 'LON', 'R', 'BX', 'BY', 'BZ', 'GR', 'GTH', 'GPH', 'PARN', 'PARNLAM', 'PARD', 'PARLATC', 'PARLONC');

end

function grid = l_grid(d, lat0, dlat, lon0, dlon, nx, ny, nz)

grid.nx = nx;
grid.ny = ny;
grid.nz = nz;

lsx = (lat0 + (0:nx-1)*dlat)/180*pi;
lsy = (lon0 + (0:ny-1)*dlon)/180*pi;
lsz = 1 + (0:nz-1)*dlat/180*pi;

grid.latc = (lsx(end) + lsx(1))/2;
grid.lonc = (lsy(end) + lsy(1))/2;
[~, VCS2VAR] = crdGetPictPlane2PhsphPlaneTrans(grid.latc, grid.lonc);

grid.dLL = (lsx(end) - lsx(1)) * d / 2;

grid.x = zeros(nx, ny, nz);
grid.y = zeros(nx, ny, nz);
grid.z = zeros(nx, ny, nz);

grid.r = zeros(nx, ny, nz);
grid.t = zeros(nx, ny, nz);
grid.p = zeros(nx, ny, nz);

for kx = 1:nx
    for ky = 1:ny
        for kz = 1:nz
            grid.t(kx, ky, kz) = pi/2-lsx(kx);
            grid.p(kx, ky, kz) = lsy(ky);
            grid.r(kx, ky, kz) = lsz(kz);
            
            st = sin(grid.t(kx, ky, kz));
            ct = cos(grid.t(kx, ky, kz));
            sp = sin(grid.p(kx, ky, kz));
            cp = cos(grid.p(kx, ky, kz));
            
            v(1) = grid.r(kx, ky, kz)*ct;
            v(2) = grid.r(kx, ky, kz)*st*sp;
            v(3) = grid.r(kx, ky, kz)*st*cp;
            
            vt = VCS2VAR*v';
            
            grid.x(kx, ky, kz) = vt(1);
            grid.y(kx, ky, kz) = vt(2);
            grid.z(kx, ky, kz) = vt(3)-1;
            
            grid.ps(kx, ky, kz) = asin(vt(1)/grid.r(kx, ky, kz));
            grid.ls(kx, ky, kz) = asin(vt(2)/(grid.r(kx, ky, kz)*cos(grid.ps(kx, ky, kz))));
        end
    end
end

end