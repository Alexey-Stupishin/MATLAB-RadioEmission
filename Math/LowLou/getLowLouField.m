function B = getLowLouField(n, nlambda, d, Phi, grid, fname)

if ~exist('fname', 'var') || isempty(fname)
    [T, Y, lambda] = getLowLouPN(n, nlambda, 1000);
else
    [T, Y, lambda] = getLowLouPNFromFile(fname, n, nlambda);
end
LL.n = n;
LL.a = sqrt(lambda);
LL.mus = T;
LL.PPd = Y;

B.x = zeros(grid.nx, grid.ny, grid.nz);
B.y = zeros(grid.nx, grid.ny, grid.nz);
B.z = zeros(grid.nx, grid.ny, grid.nz);
for kx = 1:grid.nx
    for ky = 1:grid.ny
        for kz = 1:grid.nz
            [B.x(kx, ky, kz), B.y(kx, ky, kz), B.z(kx, ky, kz)] = getLowLouFieldInPoint(LL, d, Phi, [grid.x(kx, ky, kz) grid.y(kx, ky, kz) grid.z(kx, ky, kz)]);
        end
    end
    disp(['kx=' num2str(kx) ', ' num2str(kx/grid.nx*100) '%'])
end

end
