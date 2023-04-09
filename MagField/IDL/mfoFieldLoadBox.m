function mfoFieldLoadBox

filename = wfr_getFilename('sav');
if isempty(filename)
    return
end
field = iouSAV2Data(filename);

if isfield(field, 'MFODATA')
    BX = field.MFODATA.BX;
    BY = field.MFODATA.BY;
    BZ = field.MFODATA.BZ;
elseif isfield(field, 'BOX')
    BX = permute(field.BOX.BY, [2 1 3]);
    BY = permute(field.BOX.BX, [2 1 3]);
    BZ = permute(field.BOX.BZ, [2 1 3]);
elseif isfield(field, 'BX') && isfield(field, 'BY') && isfield(field, 'BZ') 
    BX = permute(field.BY, [2 1 3]);
    BY = permute(field.BX, [2 1 3]);
    BZ = permute(field.BZ, [2 1 3]);
else
    disp('file structure error!')
    return
end

iouData2BIN([filename '.bin'], 'BX', 'BY', 'BZ');

end
