function mfoFieldBoxExtract

fname = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd';

srcdata = iouBIN2Data(fname);
[~, ~, ~, ~, ~, Bsrc] = fpuFieldVal(srcdata);

% left
v = [112 542];
h = [166 584];
[v(2), mv] = mfoTrimSize2Depth(v(2)-v(1)+1, v(1));
[h(2), mh] = mfoTrimSize2Depth(h(2)-h(1)+1, h(1));
Nz = ceil(max([v(2)-v(1)+1 h(2)-h(1)+1])*0.7);
to_z = mfoTrimSize2Depth(Nz, 1);

BX = Bsrc.x(v(1):v(2), h(1):h(2), 1:to_z);
BY = Bsrc.y(v(1):v(2), h(1):h(2), 1:to_z);
BZ = Bsrc.z(v(1):v(2), h(1):h(2), 1:to_z);
iouData2BIN([fname '.left'], 'BX', 'BY', 'BZ', 'v', 'h', 'to_z');

% right
v = [111 546];
h = [511 987];
[v(2), mv] = mfoTrimSize2Depth(v(2)-v(1)+1, v(1));
[h(2), mh] = mfoTrimSize2Depth(h(2)-h(1)+1, h(1));
Nz = ceil(max([v(2)-v(1)+1 h(2)-h(1)+1])*0.7);
to_z = mfoTrimSize2Depth(Nz, 1);

BX = Bsrc.x(v(1):v(2), h(1):h(2), 1:to_z);
BY = Bsrc.y(v(1):v(2), h(1):h(2), 1:to_z);
BZ = Bsrc.z(v(1):v(2), h(1):h(2), 1:to_z);
iouData2BIN([fname '.right'], 'BX', 'BY', 'BZ', 'v', 'h', 'to_z');

end
