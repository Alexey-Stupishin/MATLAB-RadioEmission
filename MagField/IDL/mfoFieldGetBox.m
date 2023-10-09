function B = mfoFieldGetBox(savData)

BX = [];
BY = [];
BZ = [];
if isfield(savData, 'MFODATA')
    BX = savData.MFODATA.BX;
    BY = savData.MFODATA.BY;
    BZ = savData.MFODATA.BZ;
elseif isfield(savData, 'BOX')
    BX = permute(savData.BOX.BY, [2 1 3]);
    BY = permute(savData.BOX.BX, [2 1 3]);
    BZ = permute(savData.BOX.BZ, [2 1 3]);
elseif isfield(savData, 'BX') && isfield(savData, 'BY') && isfield(savData, 'BZ') 
    BX = permute(savData.BY, [2 1 3]);
    BY = permute(savData.BX, [2 1 3]);
    BZ = permute(savData.BZ, [2 1 3]);
elseif isfield(savData, 'BX3')
    BX = permute(savData.BX3, [2 1 3]);
elseif isfield(savData, 'BY3')
    BY = permute(savData.BY3, [2 1 3]);
elseif isfield(savData, 'BZ3')
    BZ = permute(savData.BZ3, [2 1 3]);
else
    disp('file structure error!')
    return
end

B.BX = BX;
B.BY = BY;
B.BZ = BZ;

end
