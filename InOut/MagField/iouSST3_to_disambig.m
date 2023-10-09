function data = iouSST3_to_disambig(ME, index, trimh, trimv)

global mfrdata

sz = size(ME.absB);
istrimv = true;
if ~exist('trimv', 'var')
    trimv = 1:sz(1);
    istrimv = false;
end
istrimh = true;
if ~exist('trimh', 'var')
    trimh = 1:sz(2);
    istrimh = false;
end

if istrimv || istrimh
    [ME, index] = mfoTrimField(ME, trimh, trimv, [], index);
end

[date, time] = astDateTimeStrings(index.date_obs);

data.OBS_DATE = date;
data.OBS_TIME = time;
data.XSCALE = index.cdelt1;
data.YSCALE = index.cdelt2;
data.XCEN = 0;
data.YCEN = 0;
% data.XCEN = index.crval1 + ((index.naxis1+1)/2 - index.crpix1);
% data.YCEN = index.crval2 + ((index.naxis2+1)/2 - index.crpix2);
data.ABS_TIME = srvGetAbsTime(data.OBS_DATE, data.OBS_TIME);
[solar_p, ~, solar_r] = asuGetSolarPar(astAnyDateTimeJD([date 'T' time]));
data.SOLAR_R = solar_r;
data.SOLAR_P = solar_p;
data.SOLAR_B = 0;
data.DATA_P = 0;
data.DATA_B = 0;
data.TELESCOP = index.telescope;

data.data.absB = double(ME.absB);
data.data.azim = double(ME.azim);
data.data.incl = double(ME.incl);

data.trim.XSCALE = data.XSCALE;
data.trim.XCEN = data.XCEN;
data.trim.YSCALE = data.YSCALE;
data.trim.YCEN = data.YCEN;
data.trim.SOLAR_R = data.SOLAR_R;
data.trim.SOLAR_P = data.SOLAR_P;
data.trim.SOLAR_B = data.SOLAR_B;
data.trim.DATA_P = data.DATA_P;
data.trim.DATA_B = data.DATA_B;
data.trim.ABS_TIME = data.ABS_TIME;
sz = size(data.data.absB);
data.trim.DATA_TRIM.X = 1:sz(1);
data.trim.DATA_TRIM.Y = 1:sz(2);
data.trim.DATA_DT = 0;

data.trim.data.absB = data.data.absB;
data.trim.data.incl = data.data.incl;
data.trim.data.azim = data.data.azim;

data.trim.Result.transform = crdObserv2PhotCopy(size(data.data.absB), data.trim);
Bme.absB = ME.absB;
Bme.incl = ME.incl;
Bme.azim = ME.azim;
Bs = fpuMEField2QStokes(Bme);
data.trim.Result.preproc.V = Bs.V;

mfrdata = data;

end
