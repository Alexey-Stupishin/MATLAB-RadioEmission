function ar_info = SRSParse(filename)

ar_info = [];

fid = fopen(filename, 'r');

state = 0;
    % 0 - find sunspots AR section
    % 1 - find sunspots AR
    % 2 - find plage
while ~feof(fid)
    s = fgets(fid);
    if isempty(s)
        return
    end
    n = length(s);
    isHeader = s(1) == ':' || s(1) == '#';
    isARSect = n > 1 && strcmp(s(1:2), 'I.');
    isPlageSect = n > 2 && strcmp(s(1:3), 'IA.');
    isReturnSect = n > 2 && strcmp(s(1:3), 'II.');
    ar = NaN;
    if n > 3
        ar = str2double(s(1:4));
    end
    
    switch state
        case 0
            if isHeader
                continue
            end
            if isARSect
                state = 1;
            end
            
        case 1
            if isPlageSect
                state = 2;
            elseif ~isnan(ar)
                ar_info = [ar_info l_parseAR(s, state)];
            end

        case 2
            if isReturnSect
                break
            elseif ~isnan(ar)
                ar_info = [ar_info l_parseAR(s, state)];
            end
    end
end

fclose(fid);

end

%--------------------------------------------------------------------------
function ar_info = l_parseAR(s, state)

ar_info = struct('AR', [], 'Latitude', [], 'Longitude', [], 'McIntosh', [], 'Hale', [], 'Carrington', [], 'Area', [], 'LL', [], 'NN', []);

ar_info.AR = str2double(s(1:4));
d = pick(state == 1, 0, 1);

latsign = pick(s(d+6) == 'N', 1, -1);
ar_info.Latitude = latsign*str2double(s(d+(7:8)));
lonsign = pick(s(d+9) == 'W', 1, -1);
ar_info.Longitude = lonsign*str2double(s(d+(10:11)));
if length(s) < d+17
    return
end
ar_info.Carrington = str2double(s(d+(15:17)));

if state == 2
    return
end

ar_info.Area = str2double(s(18:23));
ar_info.McIntosh = s(25:27);

ar_info.LL = str2double(s(29:31));
ar_info.NN = str2double(s(33:36));

ar_info.Hale = strtrim(s(38:end));

% 20110725 typo
if strcmp(ar_info.Hale, 'pha')
    ar_info.NN = 0;
    ar_info.Hale = 'Alpha';
end

end

% :Product: 0101SRS.txt
% :Issued: 2011 Jan 01 0030 UTC
% # Prepared jointly by the U.S. Dept. of Commerce, NOAA,
% # Space Weather Prediction Center and the U.S. Air Force.
% #
% Joint USAF/NOAA Solar Region Summary
% SRS Number 1 Issued at 0030Z on 01 Jan 2011
% Report compiled from data received at SWO on 31 Dec
% I.  Regions with Sunspots.  Locations Valid at 31/2400Z 
% Nmbr Location  Lo  Area  Z   LL   NN Mag Type
% 1138 N12W70   324  0010 Bxo  02   02 Beta
% 1140 N32E67   188  0180 Hsx  03   01 Alpha
% IA. H-alpha Plages without Spots.  Locations Valid at 31/2400Z Dec
% Nmbr  Location  Lo
% 1137  N17W53   308
% 1139  S26E20   234
% II. Regions Due to Return 01 Jan to 03 Jan
% Nmbr Lat    Lo
% None 

% :Product: 0414SRS.txt
% :Issued: 2021 Apr 14 0030 UTC
% # Prepared jointly by the U.S. Dept. of Commerce, NOAA,
% # Space Weather Prediction Center and the U.S. Air Force.
% #
% Joint USAF/NOAA Solar Region Summary
% SRS Number 104 Issued at 0030Z on 14 Apr 2021
% Report compiled from data received at SWO on 13 Apr
% I.  Regions with Sunspots.  Locations Valid at 13/2400Z 
% Nmbr Location  Lo  Area  Z   LL   NN Mag Type
% 2814 S22W05   008  0030 Bxo  06   06 Beta
% IA. H-alpha Plages without Spots.  Locations Valid at 13/2400Z Apr
% Nmbr  Location  Lo
% None
% II. Regions Due to Return 14 Apr to 16 Apr
% Nmbr Lat    Lo
% None 

% :Product: 0209SRS.txt
% :Issued: 2021 Feb 09 0030 UTC
% # Prepared jointly by the U.S. Dept. of Commerce, NOAA,
% # Space Weather Prediction Center and the U.S. Air Force.
% #
% Joint USAF/NOAA Solar Region Summary
% SRS Number 40 Issued at 0030Z on 09 Feb 2021
% Report compiled from data received at SWO on 08 Feb
% I.  Regions with Sunspots.  Locations Valid at 08/2400Z 
% Nmbr Location  Lo  Area  Z   LL   NN Mag Type
% None
% IA. H-alpha Plages without Spots.  Locations Valid at 08/2400Z Feb
% Nmbr  Location  Lo
% None
% II. Regions Due to Return 09 Feb to 11 Feb
% Nmbr Lat    Lo
% 2799 N22    035
% 2797 S18    357 
