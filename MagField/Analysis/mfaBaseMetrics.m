function [devx, devwx, devjx, devy, devwy, devjy, devz, devwz, devjz ...
        , deva, devwa, devja ...
        , devt, devwt, devjt ...
        , devm, devwm, devjm ...
        , devr, devwr, devjr ...
          ] = mfaBaseMetrics(B0, Bm0, phx, phy, phz)

[Babs, ~, ~, ~, ~, B] = fpuFieldVal(B0);
[Bmabs, ~, ~, ~, ~, Bm] = fpuFieldVal(Bm0);

B.x = l_phys(B.x, phx, phy, phz);
B.y = l_phys(B.y, phx, phy, phz);
B.z = l_phys(B.z, phx, phy, phz);
Bm.x = l_phys(Bm.x, phx, phy, phz);
Bm.y = l_phys(Bm.y, phx, phy, phz);
Bm.z = l_phys(Bm.z, phx, phy, phz);
Babs = l_phys(Babs, phx, phy, phz);
Bmabs = l_phys(Bmabs, phx, phy, phz);

global gMathEx4 gWIV
gMathEx4 = [];
gWIV = [];
curlEx4pr2(Bm.x, Bm.y, Bm.z);
Jm.x = gWIV.C43(:, :, :, 1);
Jm.y = gWIV.C43(:, :, :, 2);
Jm.z = gWIV.C43(:, :, :, 3);
Jmabs = fpuFieldVal(Jm);
gMathEx4 = [];
gWIV = [];
curlEx4pr2(B.x, B.y, B.z);
J.x = gWIV.C43(:, :, :, 1);
J.y = gWIV.C43(:, :, :, 2);
J.z = gWIV.C43(:, :, :, 3);
Jabs = fpuFieldVal(J);

tau = l_getScalarProd(B, Bm, Babs, Bmabs);
% sim_s = l_getScalarProd(Jm, Bm, Jmabs, Bmabs);
% sir_s = l_getScalarProd(J, B, Jabs, Babs);
sim = l_getVectorProd(Jm, Bm, Jmabs, Bmabs);
sir = l_getVectorProd(J, B, Jabs, Babs);

lng = max(phz);
devx = zeros(1, lng);
devwx = zeros(1, lng);
devjx = zeros(1, lng);
devy = zeros(1, lng);
devwy = zeros(1, lng);
devjy = zeros(1, lng);
devz = zeros(1, lng);
devwz = zeros(1, lng);
devjz = zeros(1, lng);
deva = zeros(1, lng);
devwa = zeros(1, lng);
devja = zeros(1, lng);
devt = zeros(1, lng);
devwt = zeros(1, lng);
devjt = zeros(1, lng);
devm = zeros(1, lng);
devwm = zeros(1, lng);
devjm = zeros(1, lng);
devr = zeros(1, lng);
devwr = zeros(1, lng);
devjr = zeros(1, lng);
for k = 1:lng
    [devx(k), devwx(k), devjx(k)] = l_getdev(B.x(:, :, k), Bm.x(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [devy(k), devwy(k), devjy(k)] = l_getdev(B.y(:, :, k), Bm.y(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [devz(k), devwz(k), devjz(k)] = l_getdev(B.z(:, :, k), Bm.z(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [deva(k), devwa(k), devja(k)] = l_getdev(Babs(:, :, k), Bmabs(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [devt(k), devwt(k), devjt(k)] = l_getangle(tau(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [devm(k), devwm(k), devjm(k)] = l_getarcsin(sim(:, :, k), Bmabs(:, :, k), Jmabs(:, :, k));
    [devr(k), devwr(k), devjr(k)] = l_getarcsin(sir(:, :, k), Babs(:, :, k), Jabs(:, :, k));
end

end

%--------------------------------------------------------------------------
function b = l_phys(b, phx, phy, phz)

b = b(min(phx):max(phx), min(phy):max(phy), min(phz):max(phz));

end

%--------------------------------------------------------------------------
function [dev, devw, devj] = l_getdev(b, bm, B, J)

delta = xsum2((b-bm).^2);
dev = sqrt(delta)/sqrt(xsum2(bm.^2));

deltaw = xsum2(B.*(b-bm).^2);
devw = sqrt(deltaw)/sqrt(xsum2(B.*bm.^2));

devj = [];
if exist('J', 'var')
    deltaj = xsum2(J.*(b-bm).^2);
    devj = sqrt(deltaj)/sqrt(xsum2(J.*bm.^2));
end

end

%--------------------------------------------------------------------------
function tau = l_getScalarProd(B, Bm, Babs, Bmabs)

scalprod = B.x.*Bm.x + B.y.*Bm.y + B.z.*Bm.z;
tau = scalprod./Babs./Bmabs;

end

%--------------------------------------------------------------------------
function sgm = l_getVectorProd(B, Bm, Babs, Bmabs)

v.x = B.z.*Bm.y - B.y.*Bm.z;
v.y = B.x.*Bm.z - B.z.*Bm.x;
v.z = B.y.*Bm.x - B.x.*Bm.y;
vprod = sqrt(v.x.^2 + v.y.^2 + v.z.^2);
sgm = vprod./Babs./Bmabs;

end

%--------------------------------------------------------------------------
function [dev, devw, devj] = l_getangle(ang, Ba, Ja)

dev = acosd(xsum2(ang)/numel(ang));
devw = acosd(xsum2(ang.*Ba)/xsum2(Ba));
devj = acosd(xsum2(ang.*Ja)/xsum2(Ja));

end

%--------------------------------------------------------------------------
function [dev, devw, devj] = l_getarcsin(ang, Ba, Ja)

dev = asind(xsum2(ang)/numel(ang));
devw = asind(xsum2(ang.*Ba)/xsum2(Ba));
devj = asind(xsum2(ang.*Ja)/xsum2(Ja));

end
