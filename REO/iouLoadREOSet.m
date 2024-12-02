function [hLib, xrange, xpos, freqs, right, left, diagr, M, base, Blib, mfoData, ratan] = iouLoadREOSet(mfo_file, ratan_file, ratan_swap, step, scan_idx, sel_freqs, factor)

hLib = [];
xrange = [];
xpos = [];
freqs = [];
right = [];
left = [];
diagr = [];
M = [];
base = [];
Blib = [];
ratan = [];

mfoData = mfoLoadField(mfo_file);
if isempty(mfoData)
    disp('no magnetic field file data')
    return
end
if ~exist('ratan_swap', 'var') || isempty(ratan_swap)
    ratan_swap = false;
end
ratan = iouLoadRATANData(ratan_file, ratan_swap);
if isempty(ratan)
    disp('no RATAN file data')
    return
end

if ~exist('factor', 'var') || isempty(factor)
    factor = 1;
end

mfoData.B.x = mfoData.B.x*factor;
mfoData.B.y = mfoData.B.y*factor;
mfoData.B.z = mfoData.B.z*factor;

mfoData.posangle = ratan.header.RATAN_P;

freqs = ratan.freqs;
right = ratan.right(scan_idx, :);
left = ratan.left(scan_idx, :);

if ~exist('sel_freqs', 'var') || isempty(sel_freqs)
    sel_freqs = 1:length(freqs);
end

freqs = freqs(sel_freqs);
right = right(sel_freqs);
left = left(sel_freqs);

hLib = reoInitLibrary('s:\Projects\Physics687\ProgramD64\agsGeneralRadioEmission.dll');
if hLib == 0
    return
end
    
[M, base, Blib] = reoSetField(hLib, mfoData, [step step]);
xrange = (0:M(2)-1)*step + base(2);

[~, xpos] = min(abs(xrange-ratan.pos(scan_idx)));

[diagr.H, diagr.V] =  mfoCreateRATANDiagrams(freqs, M, [step step], base, 3);
   
end
