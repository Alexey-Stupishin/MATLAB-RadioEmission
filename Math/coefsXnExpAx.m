function p = coefsXnExpAx(n)

p = zeros(n+1);

for k = 1:n+1
    p(k, 1) = 1;
    mult = k-1;
    for m = 2:k
        p(k, m) = (-1)^(m-1) * mult;
        mult = mult*(k-m);
    end
end

end
