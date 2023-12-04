function [atm, fld, cmb] = reoParseChk(fname)

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
cmb = struct('H', {}, 'lnT', {}, 'lnD', {}, 'B', {}, 'cost', {});

state = '-';
fid = fopen(fname, 'r');
while ~feof(fid)
    s = fgetl(fid);
    switch state
        case '-'
            if length(s) >= length(satm) && strncmp(s, satm, length(satm))
                state = 'a';
                continue
            elseif length(s) >= length(sfld) && strncmp(s, sfld, length(sfld))
                state = 'f';
                continue
            elseif length(s) >= length(scmb) && strncmp(s, scmb, length(scmb))
                state = 'c';
                continue
            end
        case 'a'
            if length(s) >= length(satm_) && strncmp(s, satm_, length(satm_))
                state = '-';
                continue
            end
        case 'f'
            if length(s) >= length(sfld_) && strncmp(s, sfld_, length(sfld_))
                state = '-';
                continue
            end
        case 'c'
            if length(s) >= length(scmb_) && strncmp(s, scmb_, length(scmb_))
                state = '-';
                continue
            end
    end
    
    if strcmp(state, '-')
        continue
    end
    
    switch state
        case 'a'
            res = textscan(s, '%s');
            atm = [atm struct('H', str2double(res{1}{3}), 'lnT', str2double(res{1}{4}), 'lnD', str2double(res{1}{5}))];
        case 'f'
            res = textscan(s, '%s');
            fld = [fld struct('H', str2double(res{1}{3}), 'B', str2double(res{1}{4}), 'cost', str2double(res{1}{5}))];
        case 'c'
            res = textscan(s(11:end), '%s');
            cmb = [cmb struct('H', str2double(res{1}{1}), 'lnT', str2double(res{1}{2}), 'lnD', str2double(res{1}{3}), 'B', str2double(res{1}{4}), 'cost', str2double(res{1}{5}))];
    end
end

fclose(fid);

end
