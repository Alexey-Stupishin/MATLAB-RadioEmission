function mfoTrimInterp2Files(binfile, photofile)

s = iouBIN2Data(binfile);
p = iouBIN2Data(photofile);

[BX, BY, BZ] = mfoTrimInterp2(s, p);

[path, file] = fileparts(binfile);
sz = size(BX);
outfile = fullfile(path, [file '_restored_' num2str(sz(1)) 'x' num2str(sz(2)) 'x' num2str(sz(3)), '.bin']);

iouData2BIN(outfile, 'BX', 'BY', 'BZ');

end
