function SRSFindHale()

hale = 'Alpha';
maxNeigh = 10;
offcenter = 15;
offcentlat = 20;
maxisol = 30;

load('e:\BIGData\ActiveRegions\Total_20110101_20210414\AR.mat')

cnt = 0;
for k = 1:length(AR)
    regs = AR(k).Regions;
    if length(regs) > maxNeigh
        continue
    end
    ctrl = [];
    lons = [];
    for r = 1:length(regs)
        lons = [lons regs(r).Longitude];
        if strcmp(regs(r).Hale, hale) && ~isempty(regs(r).Longitude) && abs(regs(r).Longitude) <= offcenter && abs(regs(r).Latitude) <= offcentlat
            ctrl = [ctrl r];
        end
    end
    for p = 1:length(ctrl)
        r = ctrl(p);
        delta = abs(regs(r).Longitude - lons);
        delta(r) = [];
        if all(delta > maxisol)
            disp([num2str(AR(k).Year, '%04d') ' ' num2str(AR(k).Month, '%02d') ' ' num2str(AR(k).Day, '%02d') ' -> 1' strtrim(num2str(regs(r).AR, '%04d')) ' A = ' num2str(regs(r).Area)])
            cnt = cnt+1;
        end
    end
end    

cnt

end
