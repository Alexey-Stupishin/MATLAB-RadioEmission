function kernel = asm_getKernel(r)

n = 2*r + 1;

kernel = zeros(n);

c = r + 1;
r2 = r^2;
for x = 1:n
    for y = 1:n
        if (x-c)^2 + (y-c)^2 <= r2
            kernel(x,y) = 1;
        end
    end
end

end
