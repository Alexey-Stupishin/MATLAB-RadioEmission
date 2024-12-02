function mfoFieldBoxInterpCombine(fnamesrc, fnamedst)

srcdata = iouBIN2Data(fnamesrc);
[~, ~, ~, ~, ~, Bsrc] = fpuFieldVal(srcdata);
dstdata = iouBIN2Data(fnamedst);
[~, ~, ~, ~, ~, Bdst] = fpuFieldVal(dstdata);

szsrc = size(Bsrc.x);
szdst = size(Bdst.x);
ratio = (szdst-1)/(szsrc-1);

disp(ratio);

k = round(log2(ratio(1)));
Bsrc.x = interp3(Bsrc.x, k);
Bsrc.y = interp3(Bsrc.y, k);
Bsrc.z = interp3(Bsrc.z, k);

BX = Bdst.x;
BX(:,:,2:end) = Bsrc.x(:,:,2:end);
BY = Bdst.y;
BY(:,:,2:end) = Bsrc.y(:,:,2:end);
BZ = Bdst.z;
BZ(:,:,2:end) = Bsrc.z(:,:,2:end);

iouData2BIN([fnamedst '.upd'], 'BX', 'BY', 'BZ');

end
