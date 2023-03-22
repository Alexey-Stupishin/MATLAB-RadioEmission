function out = iouBIN2Data(filename)

out = [];
fid = fopen(filename, 'r');

if fid < 0
    return
end

header = fread(fid, 1080, 'char*1');
nformat = 'integer*4';
if header(5) == '6' && header(6) == '4'
    nformat = 'integer*8';
end

tic
while true
    term = fread(fid, 1, 'integer*4');
    if term ~= 0
        break
    end

    [name, data] = iouBinReadRecord(fid, nformat);
    
    out.(name) = data;
end
toc

fclose(fid);

end
