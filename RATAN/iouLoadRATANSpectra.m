function data = iouLoadRATANSpectra(rightfile, leftfile)

[hdrr, right] = l_load(rightfile);
[hdrl, left] = l_load(leftfile);
assert(hdrl.shift == hdrr.shift)
assert(all(hdrl.freq == hdrr.freq))
assert(all(hdrl.pos == hdrr.pos))

data = hdrl;
data.Robs = right;
data.Lobs = left;

end

%--------------------------------------------------------------------------
function [hdr, data] = l_load(file)

t = dlmread(file);

hdr.shift = t(1, 1);
hdr.pos = t(1, 2:end);
hdr.freq = t(2:end, 1)' * 1e9;
data = t(2:end, 2:end)' * 1e-4;

end

