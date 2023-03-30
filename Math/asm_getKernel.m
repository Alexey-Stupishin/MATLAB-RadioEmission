function kernel = asm_getKernel(n)

kernel = zeros(n);

c = (n+1)/2;
r2 = (c-1)^2;
for x = 1:n
    for y = 1:n
        if (x-c)^2 + (y-c)^2 <= r2
            kernel(x,y) = 1;
        end
    end
end

end
