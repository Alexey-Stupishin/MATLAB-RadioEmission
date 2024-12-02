function mfoFieldSaveBoxFromDisamb(filename)

if ~exist('filename', 'var')
    filename = wfr_getFilename('hmi');
    if isempty(filename)
        return
    end
end

data = load(filename, '-mat');

B = data.trim.Result.minEn.Bres;

BX = permute(B.y, [2 1 3]);
BY = permute(B.x, [2 1 3]);
BZ = permute(B.z, [2 1 3]);

[path, name] = fileparts(filename);

filenamesav = fullfile(path, [name '(ML).sav']);
iouData2SAV(filenamesav, 'BX', 'BY', 'BZ');

end
