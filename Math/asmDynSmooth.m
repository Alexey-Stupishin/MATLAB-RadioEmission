function smoo = asmDynSmooth(I, half_slit_vert, half_slit_horz)

smoo = I;
from = 1;
I0 = I(1);
for k = 1:length(I)
    if I(k) >= I0-half_slit_vert && I(k) <= I0+half_slit_vert
        to = k;
    else
        break
    end
end
p = floor((from+to)/2);

for k = p:length(I)
    from = k;
    to = k;
    for t = k-1:-1:max(1, k-half_slit_horz)
        if I(t) >= I(k)-half_slit_vert && I(t) <= I(k)+half_slit_vert
            from = t;
        else
            break
        end
    end
    for t = k+1:min(k+half_slit_horz, length(I))
        if I(t) >= I(k)-half_slit_vert && I(t) <= I(k)+half_slit_vert
            to = t;
        else
            break
        end
    end
    p = polyfit((from:to)', I(from:to), 2);
    smoo(k) = (p(1)*k+p(2))*k+p(3);
end

end
