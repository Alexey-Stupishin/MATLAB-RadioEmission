function mfoFieldBoxEmbed

fname = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd';
data_base = iouBIN2Data(fname);

% left
fscr = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd.left';
data = iouBIN2Data(fscr);

v = data.v(1):data.v(2);
h = data.h(1):data.h(2);
z = 1:data.to_z;

clear data

femb = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd_M25_S3_r_nm_left.out';
data_emb = iouBIN2Data(femb);

data_base.BX(v,h,z) = data_emb.BX;
data_base.BY(v,h,z) = data_emb.BY;
data_base.BZ(v,h,z) = data_emb.BZ;

% right
fscr = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd.right';
data = iouBIN2Data(fscr);

v = data.v(1):data.v(2);
h = data.h(1):data.h(2);
z = 1:data.to_z;

clear data

femb = 'g:\BIGData\Work\ISSI\12723\Process\Trim\641x1121\Potential\HMI+SST_combtrim_1121x641_BND_sst_641x1121x577.bin.upd_M25_S3_r_nm_right.out';
data_emb = iouBIN2Data(femb);

data_base.BX(v,h,z) = data_emb.BX;
data_base.BY(v,h,z) = data_emb.BY;
data_base.BZ(v,h,z) = data_emb.BZ;

BX = data_base.BX;
BY = data_base.BY;
BZ = data_base.BZ;
iouData2BIN([fname '.L+R'], 'BX', 'BY', 'BZ');

end
