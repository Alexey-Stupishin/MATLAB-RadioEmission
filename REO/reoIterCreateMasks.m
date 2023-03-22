function masks = reoIterCreateMasks(v, B)

sum = false(size(B));
v = [v Inf];
for k = 2:length(v)
    masks(k-1).mask = false(size(B));
    masks(k-1).mask(B >= v(k-1) & B < v(k)) = true;
    sum = sum | masks(k-1).mask;
end

end
