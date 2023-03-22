function map = gstMapMult(map, diagr, diagrV, arcstep, pos)

if length(arcstep) == 1
    arcstep = [arcstep arcstep];
end

map(isnan(map)) = 0;
map = map .* repmat(diagrV', 1, size(map, 2));
cd = floor((length(diagr)+1)/2);
xp = cd-pos+(1:size(map, 2));
dp = interp1(1:length(diagr), diagr, xp);
map = map .* repmat(dp, size(map, 1), 1)/arcstep(2);

end
