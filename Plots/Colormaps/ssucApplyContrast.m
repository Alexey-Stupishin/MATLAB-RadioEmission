function map = ssucApplyContrast(map, contrast)

n = size(map, 1);
last = n - 1;
tm = (0:last)'/last;
tc = tm.^contrast;
map = [interp1(tm, map(:,1), tc) interp1(tm, map(:,2), tc) interp1(tm, map(:,3), tc)];

end
