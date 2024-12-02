function d = mfm_report(out)

d = [];
if ~isfield(out, 'counter')
    return
end

d.max_depth = max(out.depth);
idx = find(out.depth == 1);
d.last_succ = numel(idx);
d.last_total = out.counter;
d.dthetaT = out.dthetaT(end);
d.dthetaBT = out.dthetaBT(end);
d.residualT = out.residualT(end);
d.time = out.time2;

d.dtheta = out.dtheta(:, end);
d.dthetaB = out.dthetaB(:, end);
d.residual = out.residual(:, end);

d.dL = out.dL(end);
d.L = out.L(:, end);
L = sum(d.L);
LD = sum(out.LD(:, end));
d.div_part = LD/L;

d.sigma = asind(out.sS(:, end) ./ out.sSW(:, end));
d.sigmaJ = asind(out.sSJ(:, end) ./ out.sJ(:, end));
d.sigmaB = asind(out.sSB(:, end) ./ out.sB(:, end));

sS = 0;
sSW = 0;
sSJ = 0;
sJ = 0;
sSB = 0;
sB = 0;
for k = 2:size(out.sS, 1)
    sS = sS + out.sS(k, end);
    sSW = sSW + out.sSW(k, end);
    sSJ = sSJ + out.sSJ(k, end);
    sJ = sJ + out.sJ(k, end);
    sSB = sSB + out.sSB(k, end);
    sB = sB + out.sB(k, end);
end

d.sigmaT = asind(sS/sSW);
d.sigmaJT = asind(sSJ/sJ);
d.sigmaBT = asind(sSB/sB);

end
