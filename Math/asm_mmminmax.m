function [mmmin, mmmax, mmgrad, pos1, pos2, v12] = asm_mmminmax(im, row, col, kernel, isgrad)

if ~exist('isgrad', 'var')
    isgrad = false;
end

sz = size(kernel);
assert(sz(1) == sz(2))
n = sz(1);
c = floor((n+1)/2);

mmmin =  inf(size(row));
mmmax = -inf(size(row));
mmgrad = -inf(size(row));
pos1 = zeros(length(row), 2);
pos2 = zeros(length(row), 2);
v12 = zeros(length(row), 2);

try
imex = zeros(size(im)+(n-1));
imex(c:end-(c-1), c:end-(c-1)) = im;
irow = zeros(1, n^2);
icol = zeros(1, n^2);
cnt = 1;
for x = 1:n
    for y = 1:n
        irow(cnt) = x;
        icol(cnt) = y;
        cnt = cnt + 1;
    end
end
for k = 1:length(row)
    for p = 1:length(irow)
        x = irow(p);
        y = icol(p);
        if kernel(x, y)
            v = imex(row(k)+x-1, col(k)+y-1);
            mmmin(k) = min([mmmin(k) v]);
            mmmax(k) = max([mmmax(k) v]);
            if isgrad
                for p1 = p+1:length(irow)
                    x1 = irow(p1);
                    y1 = icol(p1);
                    if kernel(x1, y1)
                        v1 = imex(row(k)+x1-1, col(k)+y1-1);
                        if v1*v < 0
                            g = abs(v-v1)/norm([x-x1, y-y1]);
                            if g > mmgrad(k)
                                mmgrad(k) = g;
                                pos1(k, :) = [row(k)+x-1, col(k)+y-1];
                                pos2(k, :) = [row(k)+x1-1, col(k)+y1-1];
                                v12(k, :) = [v v1];
                            end
                        end
                    end
                end                
            end
        end
    end
end
catch sle
    stophere = 1;
end

end
