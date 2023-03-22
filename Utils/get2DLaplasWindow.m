function [w, s] = get2DLaplasWindow(L, vb)

if L == 1 || vb == 0
    w = 1;
    s = 1;
    return
end

N = floor(L/2);

%b = N^2/(1-vb);
b = N^2 * vb^2;
for kx = -N:N
    for ky = -N:N
        %w(kx+N+1, ky+N+1) = 1/(b+kx^2)/(b+ky^2);
        r = sqrt(kx^2+ky^2);
        w(kx+N+1, ky+N+1) = 1/(b+r^2);
    end
end

w = w/sum(sum(w));

C = N+1;
for r = 0:N
    s(r+1) = sum(sum(w(C-r:C+r, C-r:C+r)));
end

end
