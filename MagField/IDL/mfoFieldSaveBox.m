function mfoFieldSaveBox(filenamebox, transp, filenamesav)

if ~exist('filenamebox', 'var')
    filenamebox = wfr_getFilename('out');
    if isempty(filenamebox)
        return
    end
end
if ~exist('transp', 'var')
    transp = true;
end

data = iouBIN2Data(filenamebox);
[~, ~, ~, ~, ~, B] = fpuFieldVal(data);
if transp
    BX = permute(B.y, [2 1 3]);
    BY = permute(B.x, [2 1 3]);
    BZ = permute(B.z, [2 1 3]);
    XBOUNDS = data.YBOUNDS;
    YBOUNDS = data.XBOUNDS;
else
    BX = B.x;
    BY = B.y;
    BZ = B.z;
    XBOUNDS = data.XBOUNDS;
    YBOUNDS = data.YBOUNDS;
end
ZBOUNDS = data.ZBOUNDS;

if ~exist('filenamesav', 'var')
    [path, name] = fileparts(filenamebox);
    filenamesav = fullfile(path, [name '(ML).sav']);
end
iouData2SAV(filenamesav, 'BX', 'BY', 'BZ', 'XBOUNDS', 'YBOUNDS', 'ZBOUNDS');

end
