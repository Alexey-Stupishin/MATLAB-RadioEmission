function [name, data] = iouBinReadRecord(fid, nformat)

namelng = fread(fid, 1, 'integer*4');
storenamelng = fread(fid, 1, 'integer*4');
storename = fread(fid, storenamelng, 'char*1');
storename = char(storename');
name = storename(1:namelng);
outtype = fread(fid, 1, 'integer*4');
if outtype == 3
    fmt = 'integer*4';
elseif outtype == 4
    fmt = 'integer*8';
else
    fmt = 'double';
end
% bytesperelem = 
fread(fid, 1, 'integer*4');
% nbytes = 
fread(fid, 1, nformat);
nelems = fread(fid, 1, nformat);
ndims = fread(fid, 1, 'integer*4');
maxdims = fread(fid, 1, 'integer*4');
dims = fread(fid, maxdims, nformat);
dims = dims';

%[data, count] = fread(fid, nelems, fmt);
data = fread(fid, nelems, fmt);

if ~all(dims(2:end) == 1)
    data = reshape(data, dims(1:ndims));
end

end
