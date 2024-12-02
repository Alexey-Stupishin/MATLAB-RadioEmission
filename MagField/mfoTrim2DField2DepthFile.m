function mfoTrim2DField2DepthFile(from, step, to_depth)

fpath = 'g:\BIGData\Work\ISSI\12723\Process\Trim\Preprocess\';

fnamep = 'HMI+SST_combined';

if length(from) == 1
    from = [from from];
end

data = iouSAV2Data([fpath fnamep '.sav']);
BX = data.BX;
BY = data.BY;
BZ = data.BZ;

sz = size(BX);

tox = mfoTrimSize2Depth(sz(1), from(1), step, to_depth);
toy = mfoTrimSize2Depth(sz(2), from(2), step, to_depth);

% IDL-like coordinates!

BX = BX(from(1):step:tox, from(2):step:toy);
BY = BY(from(1):step:tox, from(2):step:toy);
BZ = BZ(from(1):step:tox, from(2):step:toy);

xs = data.XSCALE;
xc = data.XCEN;
ys = data.YSCALE;
yc = data.YCEN;

XSCALE = xs*step;
YSCALE = ys*step;

szn = size(BX);

ncx = (sz(1)+1)/2;
x1 = xc - (ncx-1)*xs;
x1n = x1+(from(1)-1)*xs;
xen = x1n + (szn(1)-1)*xs*step;
XCEN = (x1n+xen)/2;

ncy = (sz(2)+1)/2;
y1 = yc - (ncy-1)*ys;
y1n = y1+(from(2)-1)*ys;
yen = y1n + (szn(2)-1)*ys*step;
YCEN = (y1n+yen)/2;

% xn = data.XCEN + data.XSCALE*((from(1)-1+(szn(1)-1)*data.XSCALE)/2-nc+1);

iouData2BIN([fpath fnamep '_' num2str(szn(1)) 'x' num2str(szn(2)) '_trimto' num2str(to_depth) '.bin'], 'BX', 'BY', 'BZ', 'XSCALE', 'YSCALE', 'XCEN', 'YCEN');
iouData2SAV([fpath fnamep '_' num2str(szn(1)) 'x' num2str(szn(2)) '_trimto' num2str(to_depth) '.sav'], 'BX', 'BY', 'BZ', 'XSCALE', 'YSCALE', 'XCEN', 'YCEN');

end
