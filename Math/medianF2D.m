function res = medianF2D(im, hwin)

res = im;
for k1 = hwin+1:size(im, 1)-hwin
    for k2 = hwin+1:size(im, 2)-hwin
        res(k1, k2) = median(median(im(k1-hwin:k1+hwin, k2-hwin:k2+hwin)));
    end
end

end
