function s = xsumrem(s, dir, rem)

dir = sort(dir, 'descend');
for k = 1:length(dir)
    s = sum(s, dir(k));
end

if ~exist('rem', 'var')
    rem = true;
end

if rem
    sz = size(s);
    ndim = length(sz);
    dir(dir > ndim) = [];
    remdir = setdiff(1:ndim, dir);
    s = permute(s, [remdir dir]);
end

end
