function [dstr, tstr] = astDateTimeStrings(s)

t = astAnyDateTime(s);
dstr = datestr(t, 'yyyy-mm-dd');
tstr = datestr(t, 'HH:MM:SS');

end
