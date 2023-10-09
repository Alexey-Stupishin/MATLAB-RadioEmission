function v = asm_medianCircle(s, r)

kernel = asm_getKernel(r);
szk = size(kernel);
assert(szk(1) == szk(2))
assert(szk(1) == 2*r + 1)
n = szk(1);
c = floor((n+1)/2);

sz = size(s);
v = s;

collect = zeros(1, szk(1)*szk(2));
for x = 1:sz(1)
    for y = 1:sz(2)
        cnt = 0;
        for xk = max(1, 1-x+n):min(n, sz(1)-x+1)
            for yk = max(1, 1-y+n):min(n, sz(2)-y+1)
                if kernel(xk, yk)
                    cnt = cnt + 1;
                    collect(cnt) = s(x+xk-r, y+yk-r);
                end
            end
        end
        if cnt > 0
            v(x, y) = median(collect(1:cnt));
        end
    end
end

end
