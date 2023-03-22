function iouData2BIN(filename, varargin)

fid = fopen(filename, 'w');

fprintf(fid, 'AGSB64v0100000  '); % 16
fwrite(fid, [0 0], 'integer*4'); % reserved for future version pointer, 8
fwrite(fid, 0, 'integer*4'); % reserved for future version pointer, 4
DateString = datestr(datetime('now'), 'ddd mmm dd HH:MM:SS yyyy');
fprintf(fid, DateString); % 24
fwrite(fid, zeros(1, 256), 'integer*4'); % reserved for environment, 1024
fwrite(fid, 255, 'integer*4'); % header terminator, 4

for k = 2:nargin
    name = varargin{k-1};
    val = evalin('caller', name);
    if isinteger(val)
        val = int32(val);
        fmt = 'integer*4';
        bytesperelem = 4;
        outtype = 3;
    else
        val = double(val);
        fmt = 'double';
        bytesperelem = 8;
        outtype = 5;
    end
    nv = numel(val);
    nd = ndims(val);
    szd = size(val);
    sz8 = ones(1, 8);
    sz8(1:nd) = szd(1:nd);
    nbytes = nv*bytesperelem;
    namelng = length(name);
    n4 = ceil(namelng/4);
    storenamelng = n4*4;
    storename = blanks(storenamelng);
    storename(1:namelng) = name;
    
    fwrite(fid, 0, 'integer*4'); % start of block
    fwrite(fid, namelng, 'integer*4');
    fwrite(fid, storenamelng, 'integer*4');
    fprintf(fid, storename);
    fwrite(fid, outtype, 'integer*4');
    fwrite(fid, bytesperelem, 'integer*4');
    fwrite(fid, nbytes, 'integer*8');
    fwrite(fid, nv, 'integer*8');
    fwrite(fid, nd, 'integer*4');
    fwrite(fid, 8, 'integer*4');
    fwrite(fid, sz8, 'integer*8');
    
    fwrite(fid, val, fmt);
end

fwrite(fid, [255 255 255 255], 'integer*4'); %terminate
fclose(fid);

end
