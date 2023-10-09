function mfoFieldLoadBoxSave(filename)

if ~exist('filename', 'var') || isempty(filename)
    filename = wfr_getFilename('sav');
end

B = mfoFieldLoadBox(filename);

BX = B.BX;
BY = B.BY;
BZ = B.BZ;
iouData2BIN([filename '.bin'], 'BX', 'BY', 'BZ');

end
