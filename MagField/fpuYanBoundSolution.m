function Br = fpuYanBoundSolution(Bph, nz, vic, tolx, tolf)

sz = size(Bph.z);

Br.x = zeros([sz nz]);
Br.y = zeros([sz nz]);
Br.z = zeros([sz nz]);

alphasz = fpuGetAlphaZ(Bph, 2:sz(1)-1, 2:sz(2)-1);
a0 = xsum2(alphasz)/(sz(1)-2)/(sz(2)-2);
% a0 = sign(a0)*min(abs(a0), 1/max(sz));

simplex = zeros(4, 3);
simplex(1, :) = [a0 a0 a0];
simplex(2, :) = [a0/2 a0 a0];
simplex(3, :) = [a0 a0/2 a0];
simplex(4, :) = [a0 a0 a0/2];

bd = zeros([3 3 3 2]);
bd(1, :, 2, 1) = [   0 -vic    0];
bd(1, :, 2, 2) = [   0  vic    0];
bd(1, :, 3, 1) = [   0    0 -vic];
bd(1, :, 3, 2) = [   0    0  vic];
bd(2, :, 1, 1) = [-vic    0    0];
bd(2, :, 1, 2) = [ vic    0    0];
bd(2, :, 3, 1) = [   0    0 -vic];
bd(2, :, 3, 2) = [   0    0  vic];
bd(3, :, 1, 1) = [-vic    0    0];
bd(3, :, 1, 2) = [ vic    0    0];
bd(3, :, 2, 1) = [   0 -vic    0];
bd(3, :, 2, 2) = [   0  vic    0];

Bph0 = zeros(sz(1), sz(2), 3);
Bph0(:, :, 1) = Bph.x;
Bph0(:, :, 2) = Bph.y;
Bph0(:, :, 3) = Bph.z;

b = zeros(3, 1);
j = zeros(3, 1);
jB = zeros(3, 1);
bdv = zeros([3 3 2]);

tocID = tic;
total = (sz(1)-1)*(sz(2)-1)*(nz-1);
for kz = 2:nz
    for ky = 2:sz(2)-1
        for kx = 2:sz(1)-1
            point = [kx ky kz];
            [lams, iter] = NelderMead(@l_calc, @l_crit, @l_bound, simplex);
            Br.x(kx, ky, kz) = fpuYanBoundInt(Bph.x, point, lams(1));
            Br.y(kx, ky, kz) = fpuYanBoundInt(Bph.y, point, lams(2));
            Br.z(kx, ky, kz) = fpuYanBoundInt(Bph.z, point, lams(3));
            
            curr = kx-2 + (sz(1)-2)*(ky-2 + (sz(2)-2)*(kz-1));
            disp(['    kx = ' num2str(kx) ', iter = ' num2str(iter) ', ' srvProgressReportString(tocID, total, curr)])
        end
        disp(['  ky = ' num2str(ky)])
    end
    disp(['kz = ' num2str(kz)])
end

    function f = l_calc(x)
        for kcd = 1:3
            b(kcd) = fpuYanBoundInt(Bph0(:, :, kcd), point, x(kcd));
            for kcby = 1:3
                if kcd ~= kcby
                    for kdir = 1:2
                        bdv(kcd, kcby, kdir) = fpuYanBoundInt(Bph0(:, :, kcd), point+bd(kcd, :, kcby, kdir), x(kcd));
                    end
                end
            end
        end
        
        j(1) = (bdv(3, 2, 2)-bdv(3, 2, 1)) - (bdv(2, 3, 2)-bdv(2, 3, 1));
        j(2) = (bdv(1, 3, 2)-bdv(1, 3, 1)) - (bdv(3, 1, 2)-bdv(3, 1, 1));
        j(3) = (bdv(2, 1, 2)-bdv(2, 1, 1)) - (bdv(1, 2, 2)-bdv(1, 2, 1));
        
        jB(1) = j(2)*b(3) - j(3)*b(2);
        jB(2) = j(3)*b(1) - j(1)*b(3);
        jB(3) = j(1)*b(2) - j(2)*b(1);
        
        f = norm(jB)/(norm(j)*norm(b));
    end

    function x = l_bound(x)
    end

    function conv = l_crit(x, f)
        conv = all(abs(std(x, 0, 1)./mean(x, 1)) < tolx); % && all(abs(std(f, 0)./mean(f)) < tolf);
    end

end
