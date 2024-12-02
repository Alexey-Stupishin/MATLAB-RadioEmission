function mfoFieldLoadBoxSaveByComp(filename_sst_base, step)

if ~exist('step', 'var')
    step = 1;
end

% filename_base -> path + HMI+SST_combtrim_907x496_BND_sst
filex = [filename_sst_base '_bx.sav'];
filey = [filename_sst_base '_by.sav'];
filez = [filename_sst_base '_bz.sav'];

bx = iouSAV2Data(filex);
by = iouSAV2Data(filey);
bz = iouSAV2Data(filez);

BX = bx.BX(1:step:end, 1:step:end, 1:step:end);
BY = by.BY(1:step:end, 1:step:end, 1:step:end);
BZ = bz.BZ(1:step:end, 1:step:end, 1:step:end);

sz = size(BX);

iouData2BIN([filename_sst_base '_' num2str(sz(1)) 'x' num2str(sz(2)) 'x' num2str(sz(3)) '.bin'], 'BX', 'BY', 'BZ');

end
