function AR = SRSCollect(dir)

jdbreak = juliandate(datetime(2021, 04, 14, 12, 0, 0));
jd = juliandate(datetime(2011, 1, 1, 12, 0, 0));
AR = [];
while jd <= jdbreak
    t = datetime(jd, 'ConvertFrom', 'juliandate');
    filename = [dir '\' sprintf('%04d%02d%02d', t.Year, t.Month, t.Day) 'SRS.txt'];
    AR = [AR struct('JulianDay', jd, 'Year', t.Year, 'Month', t.Month, 'Day', t.Day, 'Regions', [])];
    if exist(filename, 'file') == 2
        AR(end).Regions = SRSParse(filename);
    end

    jd = jd + 1;
end

end
