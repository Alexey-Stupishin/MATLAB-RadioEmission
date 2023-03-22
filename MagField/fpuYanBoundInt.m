function Br = fpuYanBoundInt(B, point, lam)

Br = 0;
for ky = 1:size(B, 2)
    for kx = 1:size(B, 1)
        z = point(3) - 1;
        r = sqrt((kx - point(1))^2 + (ky - point(2))^2 + z^2);
        Br = Br + z*(lam*r*sin(lam*r) + cos(lam*r))*B(kx, ky)/r^3;
    end
end

end
