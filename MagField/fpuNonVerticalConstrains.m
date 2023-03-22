function Bvc = fpuNonVerticalConstrains(B, lat, lon, lim, w)

[VAR2VCS, VCS2VAR] = crdGet3DRotationMatrices(lat, lon);
Br = crd3DFieldRotate(B, VAR2VCS);

BB = fpuFieldVal(B);
Bratio = abs(Br.z)./BB;
Br.x(Bratio > lim) = Br.x(Bratio > lim).*(1 + (1 - lim./Bratio(Bratio > lim))*w);
Br.y(Bratio > lim) = Br.y(Bratio > lim).*(1 + (1 - lim./Bratio(Bratio > lim))*w);
Br.z(Bratio > lim) = sqrt(BB(Bratio > lim).^2 - Br.x(Bratio > lim).^2 - Br.y(Bratio > lim).^2).*sign(Br.z(Bratio > lim));

Bvc = crd3DFieldRotate(Br, VCS2VAR);

end
