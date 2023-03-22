function mfoFieldLoadConstrainsDisp(wmin, wmax, wdisp)
% spread weight to the neighborough levels

filename = wfr_getFilename('sav');
if isempty(filename)
    return
end

if ~exist('wmin', 'var')
    wmin = 1;
end
if ~exist('wmax', 'var')
    wmax = 1;
end
if ~exist('wdisp', 'var')
    wdisp = 0.3;
end

constr = iouSAV2Data(filename);

Babs = zeros(size(constr.MOD_B_IC, 1), size(constr.MOD_B_IC, 2), 4);
Babs(:, :, 2) = double(constr.MOD_B_IC);
Babs(:, :, 3) = double(constr.MOD_B_IC);
Babs(:, :, 4) = double(constr.MOD_B_IC);
BabsW = wmin*ones(size(Babs));
BabsW(:, :, 2) = BabsW(:, :, 2)*wdisp;
BabsW(:, :, 4) = BabsW(:, :, 4)*wdisp;
BabsW(Babs == 0) = 0;

Babs = permute(Babs, [2 1 3]);
BabsW = permute(BabsW, [2 1 3]);

[pn, fn] = fileparts(filename);
fileout = fullfile(pn, [fn '_min.bin']);
iouData2BIN(fileout, 'Babs', 'BabsW');

if isfield(constr, 'MOD_B_IC_MAX')
    Babs = zeros(size(constr.MOD_B_IC_MAX, 1), size(constr.MOD_B_IC_MAX, 2), 4);
    Babs(:, :, 2) = double(constr.MOD_B_IC_MAX);
    Babs(:, :, 3) = double(constr.MOD_B_IC_MAX);
    Babs(:, :, 4) = double(constr.MOD_B_IC_MAX);
    BabsW = wmax*ones(size(Babs));
    BabsW(:, :, 2) = BabsW(:, :, 2)*wdisp;
    BabsW(:, :, 4) = BabsW(:, :, 4)*wdisp;
    BabsW(Babs == 0) = 0;

    Babs = permute(Babs, [2 1 3]);
    BabsW = permute(BabsW, [2 1 3]);
    
    fileout = fullfile(pn, [fn '_max.bin']);
    iouData2BIN(fileout, 'Babs', 'BabsW');
end

end
