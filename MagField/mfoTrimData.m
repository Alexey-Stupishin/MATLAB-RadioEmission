function mfoData = mfoTrimData(mfoData, rx, ry)

% OUT OF USE NOW!
return

mfoData.B = l_trim3(mfoData.B, rx, ry);
if isfield(mfoData, 'Bpot') && ~isempty(mfoData.Bpot)
    mfoData.Bpot = l_trim3(mfoData.Bpot, rx, ry);
end
if isfield(mfoData, 'Bmod') && ~isempty(mfoData.Bmod)
    mfoData.Bmod = l_trim3(mfoData.Bmod, rx, ry);
end
if isfield(mfoData, 'cont') && ~isempty(mfoData.cont)
    mfoData.cont = mfoData.cont(rx, ry);
end
if isfield(mfoData, 'lon_vis') && ~isempty(mfoData.lon_vis) && isfield(mfoData, 'lat_vis') && ~isempty(mfoData.lat_vis)
    mfoData.lon_vis = mfoData.lon_vis(rx, ry);
    mfoData.lat_vis = mfoData.lat_vis(rx, ry);
    c = size(mfoData.lon_vis)/2 + 1;
    mfoData.lon = interp2(mfoData.lon_vis, c(1), c(2));
    mfoData.lat = interp2(mfoData.lat_vis, c(1), c(2));
    mfoData.vcos = crdVCos(mfoData.lat, mfoData.lon);
end

mfoData.baseP = mfoData.baseP + [mfoData.stepP(1)*(rx(1)-1) mfoData.stepP(2)*(ry(1)-1)];

% mfoData.centre ????
% mfoData.AIA ????

end

%--------------------------------------------------------------------------
function B = l_trim3(B, rx, ry)

B.x = B.x(rx, ry, :);
B.y = B.y(rx, ry, :);
B.z = B.z(rx, ry, :);

end
