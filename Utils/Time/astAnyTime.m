function [ttime, found] = astAnyTime(stime)

ttime = datetime;
ttime.Year = 0;
ttime.Month = 1;
ttime.Day = 1;
found = false;

ot = regexp(stime, '.*([0-9][0-9]):*([0-9][0-9]):*([0-9][0-9]\.*[0-9]*).*', 'tokens');
if ~isempty(ot) && length(ot{1}) == 3
    ttime.Hour = str2double(ot{1}{1});
    ttime.Minute = str2double(ot{1}{2});
    ttime.Second = str2double(ot{1}{3});
    found = true;
else
    ot = regexp(stime, '.*([0-9][0-9]):*([0-9][0-9]).*', 'tokens');
    if ~isempty(ot) && length(ot{1}) == 2
        ttime.Hour = str2double(ot{1}{1});
        ttime.Minute = str2double(ot{1}{2});
        found = true;
    end
end

end
