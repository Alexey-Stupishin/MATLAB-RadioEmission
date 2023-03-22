function Br = crd3DFieldRotate(B, R)

Br.x = R(1, 1)*B.x + R(1, 2)*B.y + R(1, 3)*B.z;
Br.y = R(2, 1)*B.x + R(2, 2)*B.y + R(2, 3)*B.z;
Br.z = R(3, 1)*B.x + R(3, 2)*B.y + R(3, 3)*B.z;

end
