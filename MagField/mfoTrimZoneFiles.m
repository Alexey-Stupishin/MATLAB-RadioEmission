function mfoTrimZoneFiles(binfile, xr, yr, zr, spec)

B0 = iouBIN2Data(binfile);

B = mfoTrimField(B0, xr, yr, zr);

[path, file] = fileparts(binfile);
sz = size(B.x);
outfile = fullfile(path, [file '_' spec '_' num2str(sz(1)) 'x' num2str(sz(2)) 'x' num2str(sz(3)), '.bin']);

BX = B.x;
BY = B.y;
BZ = B.z;

iouData2BIN(outfile, 'BX', 'BY', 'BZ');

end
