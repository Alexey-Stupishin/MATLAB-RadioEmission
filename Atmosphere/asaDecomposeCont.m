function model_mask = asaDecomposeCont(Bz, cont, exmask)

model_mask = zeros(size(Bz));

mag_qs = 10;  % 10 Gauss for QS
thr_plage = 3; % MF in plage is thr_plage times stronger than QS

Bsub = (abs(Bz) < mag_qs & exmask > 0);
cutoff_qs = xsum2(cont(Bsub))/numel(find(Bsub));

contlin = reshape(cont, [1 numel(cont)]);
usedlin = reshape(cont, [1 numel(cont)]);

% exclude sunspots
n_used = numel(find(usedlin > 0));
sub = (contlin > cutoff_qs*0.9 & usedlin);
count = numel(find(sub));
[pdf, xbin] = histcounts(cont(sub), n_used);
cdf = cumsum(pdf) / count;
[~, im] = min(abs(cdf - 0.75));
cutoff_b = xbin(im);
[~, im] = min(abs(cdf - 0.97));
cutoff_f = xbin(im);

absmag = abs(Bz);

model_mask(cont <= 0.65*cutoff_qs & exmask > 0) = 7; % umbra
model_mask(cont > 0.65*cutoff_qs & cont <= 0.9*cutoff_qs & exmask > 0) = 6; % penumbra
model_mask(cont > cutoff_f & cont <= 1.19*cutoff_qs & exmask > 0) = 3; % enhanced NW
model_mask(cont > cutoff_b & cont <= cutoff_f & exmask > 0) = 2; % NW lane
model_mask(cont > 0.9*cutoff_qs & cont <= cutoff_b & exmask > 0) = 1; % IN
model_mask(cont > 0.95*cutoff_qs & cont <= cutoff_f & absmag > thr_plage*mag_qs & exmask > 0) = 4; % plage
model_mask(cont > 1.01*cutoff_qs & absmag > thr_plage*mag_qs & exmask > 0) = 5; % facula
model_mask(~exmask) = 0; % NaN

% [0.65*cutoff_qs 0.9*cutoff_qs 0.95*cutoff_qs cutoff_qs 1.01*cutoff_qs cutoff_b cutoff_f  1.19*cutoff_qs]


end

% ID	'hmi.M_720s.20151218_082209.W85N13CR.CEA.BND'	

%        1.0052664        1326
%        1.0165217       1.0369428
% umbra: nelem=          395 abs(B) range:        849.46805       2965.4990
% penumbra: nelem=         1120 abs(B) range:        38.598600       1451.1239
% eNW: nelem=          133 abs(B) range:     0.0034774441       230.30492
% NW: nelem=          973 abs(B) range:      0.012584738       392.71815
% IN: nelem=         3304 abs(B) range:     0.0038087979       829.98714
% plage: nelem=         1452 abs(B) range:        30.001748       723.35723
% facula: nelem=          416 abs(B) range:        30.677026       392.71815
%         7793
%         5925
