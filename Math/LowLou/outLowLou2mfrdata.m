function outLowLou2mfrdata(fname, n, nlambda, sz, d, Phi, nx, nz, infname)

if ~exist('infname', 'var')
    infname = '';
end
    
lsx = linspace(-sz, sz, nx);
dx = diff(lsx);
zmax = dx(1)*(nz-1);
B = getLowLouField(n, nlambda, d, Phi, l_grid([-sz, sz], nx, [-sz, sz], nx, [0 zmax], nz), infname);
B.x = B.x*10;
B.y = B.y*10;
B.z = B.z*10;

% daz = 1.5;
% dz = 0.5;
% 
% B.x = B.x.*(1 + (rand(size(B.x)) - 0.5)* daz);
% B.y = B.y.*(1 + (rand(size(B.y)) - 0.5)* daz);
% B.z = B.z.*(1 + (rand(size(B.z)) - 0.5)* dz);

mfrdata.TELESCOP = 'LowLou';
mfrdata.INSTRUME = 'HMI-like';

params.n = n;
params.nlambda = nlambda;
params.d = d;
params.Phi = Phi;
params.stepMm = 2;

mfrdata = out2mfrdata(mfrdata, params, 1, 950, B);

mfrdata.specification = fname;

save(fname, '-struct', 'mfrdata');

end

function grid = l_grid(limx, nx, limy, ny, limz, nz)

grid.nx = nx;
grid.ny = ny;
grid.nz = nz;

lsx = linspace(limx(1), limx(2), nx);
lsy = linspace(limy(1), limy(2), ny);
lsz = linspace(limz(1), limz(2), nz);

grid.x = zeros(nx, ny, nz);
grid.y = zeros(nx, ny, nz);
grid.z = zeros(nx, ny, nz);

for kx = 1:nx
    for ky = 1:ny
        for kz = 1:nz
            grid.x(kx, ky, kz) = lsx(kx);
            grid.y(kx, ky, kz) = lsy(ky);
            grid.z(kx, ky, kz) = lsz(kz);
        end
    end
end

end
