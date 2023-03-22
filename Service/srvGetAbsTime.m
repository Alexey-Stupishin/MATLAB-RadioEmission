function t = srvGetAbsTime(sdate, stime)
%'2007-01-05' '07:26:00.637'

t = datenum([sdate 'T' stime], 'yyyy-mm-ddTHH:MM:SS');

end
