function mfoFieldLoadBoxSave(filename_sst, trimv, trimh, trimz)

if ~exist('filename_sst', 'var') || isempty(filename_sst)
    filename_sst = wfr_getFilename('sav');
end

B = mfoFieldLoadBox(filename_sst);

strim = '';
if exist('trimv', 'var') && exist('trimh', 'var') && exist('trimz', 'var')
    BX = B.BX(trimv, trimh, trimz);
    BY = B.BY(trimv, trimh, trimz);
    BZ = B.BZ(trimv, trimh, trimz);
    strim = '_trim';
else
    BX = B.BX;
    BY = B.BY;
    BZ = B.BZ;
end

iouData2BIN([filename_sst strim '.bin'], 'BX', 'BY', 'BZ');

end
