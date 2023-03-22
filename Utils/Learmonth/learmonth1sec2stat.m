function learmonth1sec2stat(dir)

%LYYMMDD.srd:
% <= 20150727
% The four digit number abcp is the flux value a.bc*10^p. for example a value of 7453 should be read as 7.45*10^3 or 7450 SFU
% 000008                4701 7701 1222 2272 4902
% 015102                                         
% 015103 7000 1101 1701 4901 8601 1232 2272 4932 

% >= 20151116
% 000021 ////// ////// ////// ////// ////// ////// ////// //////
% 213126 000000 000000 001140 -00005 -00007 -00001 -00011 000016 
% 000022 000021 000028 000726 000063 000080 000119 000208 000518 

% t = juliandate(datetime(2020, 3, 1, 4, 33, 12))
% t = datetime(v,'ConvertFrom','juliandate') % 02-Mar-2020 04:33:12
% t.Year = 2020
% t.Month = 3
% etc.

% e:\BIGData\Learmonth\lear_noontime-flux_1990.txt:
% 110101 LEAR  17      32      47      72      85     131     228     549      
% 880110 LEAR  17      28      43             102     122     248     572   
% 050121 LEAR                          66     108     162     220     558  
% 110122 LEAR   2                               1       1       4       4      

%->
%   floor(julianday),-1,-1,-1,66,108,162,220,558  

end
