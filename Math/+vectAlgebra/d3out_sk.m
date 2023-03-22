function d3out_sk(fid, sk)

global d3utils

maxs = 0;
for k = 1:length(sk)
    for kp = 2:length(sk{k})
        maxs = max(maxs, length(sk{k}{kp}));
    end
end
d3utils.lng = maxs;

for k = 1:length(sk)
    s = sprintf('%03d', k);
    for kp = 2:length(sk{k})
        s = [s sprintf('%s', out(sk{k}{kp}))];
    end
    if isnumeric(sk{k}{1})
        format = '  %+1d';
    else
        format = '  %s';
    end
    s = [s sprintf(format, sk{k}{1})];
    
    fprintf(fid, [s '\r\n']);
end

end

%--------------------------------------------------------------------------
function s = out(v)

global d3utils
n = length(v);
s = [blanks(d3utils.lng - n + 3) v];

end
