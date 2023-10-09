function res = asm_erode(im, kernel)

sz = size(kernel);
assert(sz(1) == sz(2))
n = sz(1);
c = floor((n+1)/2);

input = true(size(im));
input(im ~= 0) = true;
sz = size(im);

d = zeros(sz(1)+(n-1), sz(2)+(n-1));

for x = 1:n
    for y = 1:n
        if kernel(x, y)
            d(n-x+(1:sz(1)), n-y+(1:sz(2))) = d(n-x+(1:sz(1)), n-y+(1:sz(2))) & input;
        end
    end
end

res = d(c-1+(1:sz(1)), c-1+(1:sz(2)));

end
