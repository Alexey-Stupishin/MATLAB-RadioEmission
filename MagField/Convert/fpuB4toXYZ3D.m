function Bxyz = fpuB4toXYZ3D(B4)

Bxyz.x = B4(:, :, :, 1);
Bxyz.y = B4(:, :, :, 2);
Bxyz.z = B4(:, :, :, 3);

end
