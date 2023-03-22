function smoo = asmDynSmoothDown(smt, I, hv, hh)

Iup = I(I > max(I)/2);
sup = smt(I > max(I)/2);
d = sup./Iup;
sdw = d(d > 1);
[N, edges] = histcounts(sdw, 10);
cs = cumsum(N);
idx = find(cs > 0.9*sum(N));
smtx = smt/edges(idx(1));
smtx(smtx > I) = I(smtx > I);
smoo = asmDynSmooth(smtx, hv, hh);

end
