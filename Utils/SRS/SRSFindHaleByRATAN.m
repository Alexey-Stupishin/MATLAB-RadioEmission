function SRSFindHaleByRATAN()

hale = 'Alpha';
maxNeigh = 10;
offcenter = 25;
%maxisol = 10;
maxisolarc = 200;
minarea = 50;
date_from = 20110101;
date_to = 20211231;


ratpath = 'e:\BIGData\RATAN';
load('e:\BIGData\ActiveRegions\Total_20110101_20210414\AR.mat')
fid = fopen('c:\temp\hale_find.txt', 'w');
fid2 = fopen('c:\temp\hale_find.csv', 'w');

fprintf(fid, 'hale = %s\r\n', hale);
fprintf(fid, 'maxNeigh = %d\r\n', maxNeigh);
fprintf(fid, 'offcenter = %d degrees\r\n', offcenter);
fprintf(fid, 'maxisol = %d arcsec\r\n', maxisolarc);
fprintf(fid, 'minarea = %d MSH\r\n', minarea);
fprintf(fid, 'period %d - %d\r\n', date_from, date_to);
fprintf(fid, '\r\n');

for k = 1:length(AR)
    nYMD = AR(k).Year*10000+AR(k).Month*100+AR(k).Day;
    if nYMD < date_from
        continue
    end
    if nYMD > date_to
        break
    end
    
    regs0 = AR(k).Regions;
    regs = [];
    for kr = 1:length(regs0)
        if ~isempty(regs0(kr).Longitude) && ~isempty(regs0(kr).Latitude) && abs(regs0(kr).Longitude) <= 89 && abs(regs0(kr).Latitude) <= 89
            regs = [regs regs0(kr)];
        end
    end
    if length(regs) > maxNeigh
        continue
    end
    
    % RATAN posangles
    Year = num2str(AR(k).Year, '%04d');
    Month = num2str(AR(k).Month, '%02d');
    Day = num2str(AR(k).Day, '%02d');
    YMD = [Year Month Day];
    disp(YMD)
    ratp = fullfile(ratpath, Year, Month, Day);
    listing = dir(ratp);
    rfits = {};
    for ka = 1:length(listing)
        outs = regexp(listing(ka).name, '([0-9]*)_([0-9]*)_sun.*_out.fits', 'tokens');
        if isempty(outs) || length(outs{1}) ~= 2
            continue
        end
        rfits = [rfits{:} {listing(ka).name}];
    end
    az = [];
    for ka = 1:length(rfits)
        infile = fullfile(ratp, rfits{ka});
        rd = iouLoadFitsRATAN(infile, true);
        ratan_p = rtnGetPositionAngle(rd.AZIMUTH, rd.SOL_DEC, rd.SOLAR_P);
        az = [az struct('az', rd.AZIMUTH, 'solar_p', rd.SOLAR_P, 'solar_r', rd.SOLAR_R, 'sol_dec', rd.SOL_DEC, 'ratan_p', ratan_p, 'date', rd.OBS_DATE, 'time', rd.OBS_TIME, 'file', infile)];
    end
    if isempty(az)
        continue
    end
    
    ctrl = [];
    lats = [];
    lons = [];
    for kr = 1:length(regs)
        lats = [lats regs(kr).Latitude];
        lons = [lons regs(kr).Longitude];
        ctrl = [ctrl (strcmp(regs(kr).Hale, hale) && regs(kr).Area >= minarea)];
    end
    for kr = 1:length(regs)
        if ~ctrl(kr)
            continue
        end
        
        goodaz = [];
        maxdist = 0;
        minisol = Inf;
        for ka = 1:length(az)
            [x, y] = crdLatLon2XY(lats, lons);
            [xr, yr] = crdXYRotate(x, y, -az(ka).ratan_p);
            [latr, lonr] = crdXY2LatLon(xr, yr);
            dist = sqrt(latr(kr)^2 + lonr(kr)^2);
            if dist > offcenter
                continue
            end
%             delta = abs(lonr(kr) - lonr);
%             delta(kr) = [];
%             isol = min(delta);
%             if isol > maxisol
            delta = abs(yr(kr) - yr)*az(ka).solar_r;
            delta(kr) = [];
            isol = min(delta);
            if isol > maxisolarc
                maxdist = max(maxdist, dist);
                minisol = min(minisol, isol);
                goodaz = [goodaz az(ka).az];
            end
        end
        
        if ~isempty(goodaz)
            l_print(fid, YMD, regs(kr), maxdist, minisol, goodaz);
            [~, im] = min(abs(goodaz));
            ka = find(goodaz(im) == [az.az], 1);
            l_print2(fid2, regs(kr), az(ka));
        end
    end
end    

fclose(fid);
fclose(fid2);

end

%--------------------------------------------------------------------------
function l_print(fid, YMD, reg, maxdist, minisol, goodaz)

azs = '';
for k = 1:length(goodaz)
    if ~isempty(azs)
        azs = [azs ','];
    end
    azs = [azs num2str(goodaz(k))];
end

lat = [pick(reg.Latitude > 0, 'N', 'S') num2str(abs(reg.Latitude), '%02d')];
lon = [pick(reg.Longitude > 0, 'W', 'E') num2str(abs(reg.Longitude), '%02d')];

fprintf(fid, '%s AR1%04d %s %s%s %s %5.1f %5.1f %s\r\n', YMD, reg.AR, reg.Hale, lat, lon, ...
                                                         l_out(reg.Area, '%d', 4), maxdist, minisol, azs);

end

%--------------------------------------------------------------------------
function s = l_out(v, format, lim)

s = num2str(v, format);
if length(s) < lim
    s = [blanks(lim-length(s)) s];
end

end

%--------------------------------------------------------------------------
function l_print2(fid, reg, az)

[x, y] = crdLatLon2XY(reg.Latitude, reg.Longitude);
x = x*az.solar_r;
xr = x + 150*[-1 1];
y = y*az.solar_r;
yr = y + 150*[-1 1];

fprintf(fid, '%s,%s,%d,%d,%d,%d,%d\r\n', az.date, az.time, reg.AR+10000, xr(1), xr(2), yr(1), yr(2));

end

