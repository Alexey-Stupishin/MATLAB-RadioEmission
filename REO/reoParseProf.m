function reoParseProf(fname)

% ** >ATMOS
% 000 atmos: 0.000000e+00 8.792246e+00 3.206148e+01
% ** <ATMOS
%  
% ** >FIELD
% 000 field: 0.000000e+00 1.755593e+03 9.226740e-01
% ** <FIELD
%  
% ** >COMB
% 000 same : 0.000000e+00 1.755593e+03 9.226740e-01 | 8.792246e+00 3.206148e+01
% ** <COMB

satm = '** >ATMOS';
satm_ = '** <ATMOS';
sfld = '** >FIELD';
sfld_ = '** <FIELD';
scmb = '** >COMB';
scmb_ = '** <COMB';

atm = struct('H', {}, 'lnT', {}, 'lnD', {});
fld = struct('H', {}, 'B', {}, 'cost', {});
cmb = struct('H', {}, src, {}, 'lnT', {}, 'lnD', {}, 'B', {}, 'cost', {});

state = '-';
fid = fopen(fname, 'r');
while ~feof(fid)
    s = fgetl(fid);
    switch state
        case '-'
            if length(s) >= length(satm) && strncmp(s, satm, length(satm))
                state = 'a';
            end
        otherwise
    end
    
    switch state
        case '-'
            % do nothing
        case 'a'
            ot = regexp(s, [], 'tokens');
        otherwise
    end
end

fclose(fid);

end
