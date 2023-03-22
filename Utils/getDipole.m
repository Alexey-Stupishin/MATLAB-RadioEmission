function [Bme, Bme180, B] = getDipole(nx, ny, posx, posy, d, mu)

B.x = zeros(nx, ny);
B.y = zeros(nx, ny);
B.z = zeros(nx, ny);

for kx = 1:size(B.x, 1)
    for ky = 1:size(B.x, 2)
        for n = 1:length(posx)
            rx = posx(n) - kx; 
            ry = ky - posy(n); 
            rxy = sqrt(rx^2 + ry^2);
            r = sqrt(rxy^2 + d(n)^2);
            cost = d(n)/r;
            sint = rxy/r;
            B.z(kx, ky) = B.z(kx, ky) + mu(n)/r^3 * (3*cost^2 - 1);
            Btr = mu(n)/r^3 * (3*cost*sint);
            if (rxy ~= 0)
                B.x(kx, ky) = B.x(kx, ky) - Btr * rx/rxy;
                B.y(kx, ky) = B.y(kx, ky) + Btr * ry/rxy;
            end
        end
    end
end

% ssuCQ(B.x, B.y, B.z)

Bme = fpuXYZField2ME(B);

Bme180 = Bme;
Bme180.azim(Bme180.azim < 0) = Bme180.azim(Bme180.azim < 0) + 180;

end
