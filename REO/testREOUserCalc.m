function testREOUserCalc

mfoData = mfoLoadField('s:\Projects\Matlab\ModelsReo\dip_140_05_16e8.mat');
if isempty(mfoData)
    return
end
mfoData.B.x = mfoData.B.x*1.5;
mfoData.B.y = mfoData.B.y*1.5;
mfoData.B.z = mfoData.B.z*1.5;

if isempty(mfoData)
    return
end

hLibL = utilsLoadLibrary('s:\Projects\CPP\ProgramD64\WWNLFFFReconstruction.dll');
if hLibL == 0
    return
end

par.height_from = 2;
par.B_from = 10;
par.por = 30;
[coords, linesLength, avField, status] = mfoCalcLinesSet(hLibL, mfoData.B, par);
figure;
for k = 1:length(linesLength)
    
end

% B = fpuFieldVal(mfoData.B);
% xsurf(B(:, :, 1))

utilsFreeLibrary(hLibL);

mfoData.posangle = 0;
step = 1;

H = [1 1e8 1.1e8 3e8 3.5e8 2e10];
T = [1e4 1e4 2e6 2.1e6 2.3e6 3e6];
D = 3e15./T;

harms = 2:4;
pTauL = 100;

freq = 7e9;

hLib = reoInitLibrary();
if hLib == 0
    return
end

[M, base, Bm] = reoSetField(hLib, mfoData, [step step]);
xrange = (0:M(2)-1)*step + base(2);

% [diagr.H, diagr.V] =  mfoCreateRATANDiagrams(freq, M, [step step], base, 3);

% B = fpuFieldVal(Bm);
% Bph = B(:, :, 1);
% xsurf(Bph)
% lines
% gyrolayers Zhel. picture

mask = [];
tic
[ depthRight, pFRight, pTauRight, pHLRight, pFLRight, psLRight ...
 ,depthLeft, pFLeft, pTauLeft, pHLLeft, pFLLeft, psLLeft ...
] = ...
 	reoCalculate(hLib, H, T, D, freq, harms, pTauL, mask);
toc

utilsFreeLibrary(hLib);

figure; imagesc(pFRight); set(gca, 'DataAspectRatio', [1 1 1]); colorbar
figure; imagesc(pFLeft); set(gca, 'DataAspectRatio', [1 1 1]); colorbar

scanR = gstConvolveMap(hLib, pFRight, freq);
scanL = gstConvolveMap(hLib, pFLeft, freq);

xplot(xrange, scanR)
plot(xrange, scanL)

end
