function iouData2SAV(filename, varargin)

fid = fopen(filename, 'w');


fwrite(fid, 'S', 'char*1');
fwrite(fid, 'R', 'char*1');
fwrite(fid, 4, 'integer*2', 0, 'b');

fwrite(fid, 10, 'integer*4', 0, 'b'); % next timestamp
fwrite(fid, 1096, 'integer*4', 0, 'b'); % next pointer
fwrite(fid, 0, 'integer*4', 0, 'b'); % next pointer1 (high 32)
fwrite(fid, 0, 'integer*4', 0, 'b'); % unknown

DateString = datestr(datetime('now'), 'ddd mmm dd HH:MM:SS yyyy');
fwrite(fid, 24, 'integer*4', 1024, 'b'); % timestamp length
fprintf(fid, DateString);
fwrite(fid, 8, 'integer*4', 0, 'b');
fprintf(fid, 'AlexeyGS');
fwrite(fid, 8, 'integer*4', 0, 'b');
fprintf(fid, 'MATL2SAV');

pointer = 1148;
fwrite(fid, 14, 'integer*4', 0, 'b'); % version
fwrite(fid, 1148, 'integer*4', 0, 'b'); % next pointer
fwrite(fid, 0, 'integer*4', 0, 'b'); % next pointer1 (high 32)
fwrite(fid, 0, 'integer*4', 0, 'b'); % unknown
fwrite(fid, 11, 'integer*4', 0, 'b');
fwrite(fid, 6, 'integer*4', 0, 'b');
fprintf(fid, 'x86_64  ');
fwrite(fid, 5, 'integer*4', 0, 'b');
fprintf(fid, 'Win32   ');
fwrite(fid, 3, 'integer*4', 0, 'b');
fprintf(fid, '8.2 ');

for k = 2:nargin
    name = varargin{k-1};
    val = evalin('caller', name);
%     if (all(all(all(val-floor(val) == 0))))
%         val = int32(val);
%         fmt = 'integer*4';
%         bytesperelem = 4;
%         outtype = 3;
%     else
        val = double(val);
        fmt = 'double';
        bytesperelem = 8;
        outtype = 5;
%     end
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
    storename(1:namelng) = upper(name);
    
    varsize = nbytes + 32 + storenamelng;
    if nv > 1
        flag = 20;
        varsize = varsize + 64;
    else
        flag = 16;
    end

    pointer = pointer + varsize;

    fwrite(fid, 2, 'integer*4', 0, 'b'); % data type
    fwrite(fid, pointer, 'integer*4', 0, 'b');
    fwrite(fid, 0, 'integer*4', 0, 'b');
    fwrite(fid, 0, 'integer*4', 0, 'b');
    fwrite(fid, namelng, 'integer*4', 0, 'b');
    fprintf(fid, storename);
    fwrite(fid, outtype, 'integer*4', 0, 'b');
    fwrite(fid, flag, 'integer*4', 0, 'b'); % flag incl. array
    if nv > 1 % not scalar
        fwrite(fid, 8, 'integer*4', 0, 'b'); % arrstart ?
        fwrite(fid, bytesperelem, 'integer*4', 0, 'b');
        fwrite(fid, nbytes, 'integer*4', 0, 'b');
        fwrite(fid, nv, 'integer*4', 0, 'b');
        fwrite(fid, nd, 'integer*4', 0, 'b');
        fwrite(fid, 0, 'integer*4', 0, 'b');
        fwrite(fid, 0, 'integer*4', 0, 'b');
        fwrite(fid, 8, 'integer*4', 0, 'b');
        fwrite(fid, sz8, 'integer*4', 0, 'b');
    end
    
    fwrite(fid, 7, 'integer*4', 0, 'b'); % startcode
    fwrite(fid, val, fmt, 0, 'b');
end

fwrite(fid, [6 0 0 0], 'integer*4', 0, 'b'); %terminate
fclose(fid);

end
