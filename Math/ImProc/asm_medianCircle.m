function v = asm_medianCircle(s, r)

kernel = asm_getKernel(r);
szk = size(kernel);
assert(szk(1) == szk(2))
assert(szk(1) == 2*r + 1)
n = szk(1);

kernel(r+1, r+1) = 0;

sz = size(s);
v = s;

collect = zeros(1, szk(1)*szk(2));
for x = 1:sz(1)
    for y = 1:sz(2)
        cnt = 0;
        for xk = 1:n
            for yk = 1:n
                if ~isnan(s(x, y))
                    xx = x+xk-r-1;
                    yy = y+yk-r-1;
                    if kernel(xk, yk) && xx > 0 && xx <= sz(1) && yy > 0 && yy <= sz(2) && ~isnan(s(xx, yy))
                        cnt = cnt + 1;
                        collect(cnt) = s(xx, yy);
                    end
                end
            end
        end
        if cnt > 0
            v(x, y) = median(collect(1:cnt));
        end
    end
end

end
