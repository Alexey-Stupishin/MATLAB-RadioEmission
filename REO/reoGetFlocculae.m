function [RB, LB, RBall, LBall] = reoGetFlocculae(hLib, mask, maskn, freqs, pos, diagrH, diagrV, step, param)

load('s:\Projects\Matlab\MatlabUtils\Atmosphere\Fontenla2009.mat');

gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree', 1);
gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree.Only', 1);

RB = zeros(length(freqs), length(pos));
LB = zeros(length(freqs), length(pos));
RBall = zeros(length(freqs), size(mask, 2), length(pos));
LBall = zeros(length(freqs), size(mask, 2), length(pos));
for k = 1:length(freqs)
    pFRightW = zeros(size(mask));
    pFLeftW = zeros(size(mask));
    for n = maskn
        pFRightn = zeros(size(mask));
        pFLeftn = zeros(size(mask));
        HB = f2009.profs(n).H;
        TB = f2009.profs(n).TEMP;
        DB = f2009.profs(n).NNE;
        [~, pFRight, ~, ~, ~, ~, ...
         ~, pFLeft] = reoCalculate(hLib, HB, TB, DB, freqs(k), param.harms, param.pTauL);
        selmask = mask == n;
        pFRightn(selmask) = pFRight(selmask);
        pFRightW = pFRightW + pFRightn;
        pFLeftn(selmask) = pFLeft(selmask);
        pFLeftW = pFLeftW + pFLeftn;
    end
    scanRB = gstMapConv(pFRightW, diagrH(k,:), diagrV(k,:), step, 'same');
    scanLB = gstMapConv(pFLeftW, diagrH(k,:), diagrV(k,:), step, 'same');
    for p = 1:length(pos)
        RB(k, p) = scanRB(pos(p));
        LB(k, p) = scanLB(pos(p));
        RBall(k, :, p) = scanRB;
        LBall(k, :, p) = scanLB;
    end
end

gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree', 0);
gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree.Only', 0);

end
