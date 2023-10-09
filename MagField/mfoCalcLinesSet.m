function [coords, linesLength, avField, status] = mfoCalcLinesSet(hLib, B, par)

sz = size(B.x);
BB = fpuFieldVal(B);

if ~exist('par', 'var')
    par = [];
end

if ~isfield(par, 'limV')
    limV = [1, sz(1)];
else
    limV = par.limV;
end
if ~isfield(par, 'limH')
    limH = [1, sz(2)];
else
    limH = par.limH;
end
rx = limV(1):par.por:limV(2);
ry = limH(1):par.por:limH(2);
rz = par.height_from;
seeds = [];
for kx = rx
    for ky = ry
        for kz = rz
            if BB(round(kx), round(ky), round(rz)) >= par.B_from
                seeds = [seeds [kx-1; ky-1; kz-1]];
            end
        end
    end
end

[~, ~, avField, ~, ~, ~, ~, ~, coords, ~, linesLength, ~, status] = ...
    mfoGetLines(hLib, sz, B.x, B.y, B.z, size(seeds, 2), seeds, 1e8, 0, 0, 1);

end
