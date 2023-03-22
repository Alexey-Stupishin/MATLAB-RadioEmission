function lanz = asmGetLanczosWindow(a, n)
% Lanczos half-window, n = discret on 0...1 interval

np = a*n+1;

lanz = zeros(1, np);
lanz(1) = 1;
for k = 2:np
    x = (k-1)/n * pi;
    lanz(k) = a*sin(x)*sin(x/a)/x^2;
end
    
end
