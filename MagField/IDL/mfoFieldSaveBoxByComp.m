function mfoFieldSaveBoxByComp(filenamebox)

if ~exist('filenamebox', 'var')
    filenamebox = wfr_getFilename('out');
    if isempty(filenamebox)
        return
    end
end

data = iouBIN2Data(filenamebox);
[~, ~, ~, ~, ~, B] = fpuFieldVal(data);

BX = single(permute(B.y, [2 1 3]));
BY = single(permute(B.x, [2 1 3]));
BZ = single(permute(B.z, [2 1 3]));

[path, name] = fileparts(filenamebox);

filenamesav = fullfile(path, [name '_bx(ML).sav']);
iouData2SAV(filenamesav, 'BX', 'format=single');
filenamesav = fullfile(path, [name '_by(ML).sav']);
iouData2SAV(filenamesav, 'BY', 'format=single');
filenamesav = fullfile(path, [name '_bz(ML).sav']);
iouData2SAV(filenamesav, 'BZ', 'format=single');

end
