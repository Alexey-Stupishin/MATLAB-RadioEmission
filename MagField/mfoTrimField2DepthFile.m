function mfoTrimField2DepthFile(from, step, to_depth)

fpath = 'g:\BIGData\Work\ISSI\12723\Process\Trim\Potential\';

fnamep = 'HMI+SST_combined_(1  1)_3_(';
fnames = '357  603  423';
% fnamep = 'HMI_source_(1  1)_1_(';
% fnames = '251  424  297';

fnamet = ')';

if length(from) == 1
    from = [from from];
end

data = iouBIN2Data([fpath fnamep fnames fnamet '.bin']);
BX = data.BX;
BY = data.BY;
BZ = data.BZ;

sz = size(BX);

tox = mfoTrimSize2Depth(sz(1), from(1), step, to_depth);
toy = mfoTrimSize2Depth(sz(2), from(2), step, to_depth);
Nz = ceil(max([tox toy])*0.7);
toz = mfoTrimSize2Depth(Nz, 1, step, to_depth);

BX = BX(from(1):step:tox, from(2):step:toy, 1:step:toz);
BY = BY(from(1):step:tox, from(2):step:toy, 1:step:toz);
BZ = BZ(from(1):step:tox, from(2):step:toy, 1:step:toz);

iouData2BIN([fpath fnamep num2str(size(BX)) fnamet '(trim).bin'], 'BX', 'BY', 'BZ');

end
