function s = reoGetScans(filename, id, azimuth, solar_dec, solar_p, step, freqs, H, T, D)

s = [];
mfoData = mfoLoadField(filename);

if isempty(mfoData)
    return
end

mfoData.posangle = rtnGetPositionAngle(azimuth, solar_dec, solar_p);

QT = 1;
freefree = 0;

harms = 2:3;
pTauL = 25;

hLib = reoInitLibrary(QT, freefree, 's:\Projects\Physics104\ProgramD64\agsGeneralRadioEmission.dll');
if hLib == 0
    return
end

s.filename = filename;
s.fileid = mfoData.fileid;
s.id = id;
s.time = mfoData.time;
s.lat = mfoData.lat;
s.lon = mfoData.lon;
s.step = step;
[s.M, s.base, Bm] = reoSetField(hLib, mfoData, [step step]);
B = fpuFieldVal(Bm);
Bph = B(:, :, 1);
s.B = Bph;
s.Bz = Bm.z;

s.azimuth = azimuth;
s.posangle = mfoData.posangle;
s.model.H = H;
s.model.T = T;
s.model.D = D;

s.scans = [];
for kf = 1:length(freqs)
    [depthRight, pFRight, pTauRight, pHLRight, pFLRight, psLRight, ...
     depthLeft, pFLeft, pTauLeft, pHLLeft, pFLLeft, psLLeft, ...
     scanR, scanL] = ...
        reoCalculate(hLib, H, T, D, freqs(kf), harms, pTauL, [], true);
    
    st.freq = freqs(kf);
    st.Right = scanR;
    st.Left = scanL;
    
    s.scans = [s.scans st];
end

utilsFreeLibrary(hLib);

end
