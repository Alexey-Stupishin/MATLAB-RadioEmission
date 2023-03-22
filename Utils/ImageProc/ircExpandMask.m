function mask = ircExpandMask(mask, border)

for k = 1:border
    mask = l_expand(mask);
end

end

function mask = l_expand(mask)

mex = false(size(mask)+2);
for kx = 0:2
    for ky = 0:2
        mex(1+kx:end+kx-2, 1+ky:end+ky-2) = mex(1+kx:end+kx-2, 1+ky:end+ky-2) | mask;
    end
end

mask = mex(2:end-1, 2:end-1);

end
