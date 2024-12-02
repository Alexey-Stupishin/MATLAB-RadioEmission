function data = ssuDataExtent(data, cmap, lowers, lowcrit, uppers, upcrit)

if lowers == 0 && uppers == 0
    return
end

truesize = size(cmap, 1) - lowers - uppers - 1;
step = (xmax2(data) - xmin2(data))/truesize;

data(lowcrit) = xmin2(data) - step;
for k = 1:uppers
    data(upcrit(:,:,k)) = xmax2(data) + step*k;
end

end
