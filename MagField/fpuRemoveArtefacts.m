function data = fpuRemoveArtefacts(mask, data)

data(mask) = NaN;
while any(any(mask))
    [row, col] = find(mask, 1);
    s = 0; n = 0;
    for kx = row-1:row+1
        for ky = col-1:col+1
            if mask(kx, ky)
                continue;
            end
            s = s + data(kx, ky);
            n = n + 1;
        end
    end
    data(row, col) = s/n;
    mask(row, col) = false;
end

end
