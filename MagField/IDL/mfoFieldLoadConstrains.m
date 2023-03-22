function mfoFieldLoadConstrains(wmin, wmax)

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

constr = iouSAV2Data(filename);

Babs = zeros(size(constr.MOD_B_IC, 1), size(constr.MOD_B_IC, 2), max(constr.LVL_IC)+1);
for k = 1:length(constr.LVL_IC)
    Babs(:, :, constr.LVL_IC(k)+1) = double(constr.MOD_B_IC(:, :, k));
end
BabsW = wmin*ones(size(Babs));
BabsW(Babs == 0) = 0;

Babs = permute(Babs, [2 1 3]);
BabsW = permute(BabsW, [2 1 3]);

[pn, fn] = fileparts(filename);

fileout = fullfile(pn, [fn '_min.bin']);
iouData2BIN(fileout, 'Babs', 'BabsW');

if isfield(constr, 'MOD_B_IC_MAX')
    Babs = zeros(size(constr.MOD_B_IC_MAX, 1), size(constr.MOD_B_IC_MAX, 2), max(constr.LVL_IC)+1);
    for k = 1:length(constr.LVL_IC)
        Babs(:, :, constr.LVL_IC(k)+1) = double(constr.MOD_B_IC_MAX(:, :, k));
    end
    BabsW = wmax*ones(size(Babs));
    BabsW(Babs == 0) = 0;

    Babs = permute(Babs, [2 1 3]);
    BabsW = permute(BabsW, [2 1 3]);

    fileout = fullfile(pn, [fn '_max.bin']);
    iouData2BIN(fileout, 'Babs', 'BabsW');
end

end
