function fpuFieldTranspose(filename)

a = iouBIN2Data(filename);

BX = permute(a.BY, [2 1 3]);
BY = permute(a.BX, [2 1 3]);
BZ = permute(a.BZ, [2 1 3]);

[path, file, ext] = fileparts(filename);

iouData2BIN(fullfile(path, [file '_transp' ext]), 'BX', 'BY', 'BZ')

end
