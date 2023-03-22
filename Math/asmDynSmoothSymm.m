function [Imod, smoo] = asmDynSmoothSymm(I, smt, hv, hh)

cv = conv(smt, smt, 'same');
[~, pm] = max(cv);
im = round((pm+length(I)/2)/2);
Imod = I;
for k = 1:im
    sym = 2*im-k;
    if sym <= length(I)
        Imod(k) = min(I(k), I(sym));
        Imod(sym) = Imod(k);
    end
end

smoo = asmDynSmooth(Imod, hv, hh);

end
