function [tdate, rest, found] = astAnyDate(sdate)

found = false;
tdate = datetime;

od = regexp(sdate, '.*([0-9][0-9][0-9][0-9])[-/]*([0-9][0-9])[-/]*([0-9][0-9])(.*)', 'tokens');
if ~isempty(od) && length(od{1}) == 4
    tdate.Year = str2double(od{1}{1});
    tdate.Month = str2double(od{1}{2});
    tdate.Day = str2double(od{1}{3});
    tdate.Hour = 0;
    tdate.Minute = 0;
    tdate.Second = 0;
    
    rest = od{1}{4};
    found = true;
end

end
