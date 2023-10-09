function [med, av, sgm] = medianExCenter2D(im, kernel, exclCenter)

if ~exist('exclCenter', 'var')
    exclCenter = false;
end

sz = size(kernel);
assert(sz(1) == sz(2))
n = sz(1);
c = floor((n+1)/2);

buff = zeros(1, n^2);
szim = size(im);
med = zeros(szim + n-1);
av = zeros(szim + n-1);
sgm = zeros(szim + n-1);
imex = zeros(szim + n-1);
imex(c:size(imex, 1)-c+1, c:size(imex, 2)-c+1) = im;
for k1 = c:size(imex, 1)-c+1
    for k2 = c:size(imex, 2)-c+1
        lng = 0;
        for x = 1:n
            for y = 1:n
                if exclCenter && x == c && y == c
                    continue;
                end
                if kernel(x,y)
                    lng = lng + 1;
                    buff(lng) = imex(k1+(x-c), k2+(y-c));
                end
            end
        end
        med(k1,k2) = median(buff(1:lng));
        av(k1,k2) = mean(buff(1:lng));
        sgm(k1,k2) = std(buff(1:lng));
    end
end

med = med(c:size(imex, 1)-c+1, c:size(imex, 2)-c+1);
av = av(c:size(imex, 1)-c+1, c:size(imex, 2)-c+1);
sgm = sgm(c:size(imex, 1)-c+1, c:size(imex, 2)-c+1);

end
