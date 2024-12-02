function mfoFieldSaveBox(filenamebox, transp, factor, filenamesav)

if ~exist('filenamebox', 'var')
    filenamebox = wfr_getFilename('out');
    if isempty(filenamebox)
        return
    end
end
if ~exist('transp', 'var')
    transp = true;
end
if ~exist('factor', 'var')
    factor = 1;
end

XBOUNDS = [];
YBOUNDS = [];
ZBOUNDS = [];

data = iouBIN2Data(filenamebox);
[~, ~, ~, ~, ~, B] = fpuFieldVal(data);

if factor ~= 1
    k = log2(factor);
    B.x = interp3(B.x, k);
    B.y = interp3(B.y, k);
    B.z = interp3(B.z, k);
end

if transp
    BX = permute(B.y, [2 1 3]);
    BY = permute(B.x, [2 1 3]);
    BZ = permute(B.z, [2 1 3]);
    XBOUNDS = getfieldsafe(data, 'YBOUNDS');
    YBOUNDS = getfieldsafe(data, 'XBOUNDS');
else
    BX = B.x;
    BY = B.y;
    BZ = B.z;
    XBOUNDS = getfieldsafe(data, 'XBOUNDS');
    YBOUNDS = getfieldsafe(data, 'YBOUNDS');
end
ZBOUNDS = getfieldsafe(data, 'ZBOUNDS');

if ~exist('filenamesav', 'var') || isempty(filenamesav)
    [path, name] = fileparts(filenamebox);
    filenamesav = fullfile(path, [name '(ML).sav']);
end
iouData2SAV(filenamesav, 'BX', 'BY', 'BZ', 'XBOUNDS', 'YBOUNDS', 'ZBOUNDS');

% iouData2BIN([filenamebox '.out'], 'BX', 'BY', 'BZ', 'XBOUNDS', 'YBOUNDS', 'ZBOUNDS');

end
