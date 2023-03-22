function [Hcalc, Tcalc, Dcalc, Rcalc, Lcalc, Runit, Lunit, R, cntR, L, cntL] = reoIterationCalcStep(hLib, Hin, Tin, Din, Ht1, Ht2 ...
        , freqs, idxR, idxL, diagr, step, incl_mask, Rpos, Lpos, param)
    
Hcalc = Hin;
Tcalc = Tin;
Dcalc = Din;

R = zeros(length(freqs), length(Ht1));
L = zeros(length(freqs), length(Ht1));
cntR = zeros(length(freqs),length(Ht1));
cntL = zeros(length(freqs),length(Ht1));

Rcalc = zeros(1, length(freqs));
Lcalc = zeros(1, length(freqs));
Runit = zeros(1, length(freqs));
Lunit = zeros(1, length(freqs));

for k = 1:length(freqs)
    if k == 32
        gstSetPreferenceInt(hLib, 'cycloMap.nThreadsInitial', 1);
        gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.i', 26);
        gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.j', 41);
        gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.GyroLayerProfile', 1);
    end
    [depthRight, pFRight, ~, pHLRight, ~, ~, ...
     depthLeft,  pFLeft,  ~, pHLLeft] = ...
             reoCalculate(hLib, Hcalc, Tcalc, Dcalc, freqs(k), param.harms, param.pTauL, incl_mask); % , [], true, 3, 0, 0, posRcalc, posLcalc);
%     if ~isempty(incl_mask)
%         pFRight(~incl_mask) = 0;
%         pFLeft(~incl_mask) = 0;
%     end
    useR = ~isempty(find(k == idxR, 1));
    useL = ~isempty(find(k == idxL, 1));
    
    if useR
        Rconv = gstMapConv(pFRight, diagr.H(k, :), diagr.V(k, :), step, 'same');
    %    [scanRmc, newlim] = gstConvolveMap(hLib, pFRight, freqs(k));
        if ~exist('Rpos', 'var') || isempty(Rpos)
            [~, Rpos] = max(Rconv);
        end
        Rcalc(k) = Rconv(Rpos);
        Rmult = gstMapMult(pFRight, diagr.H(k, :), diagr.V(k, :), step, Rpos);
        Runit(k) = Rcalc(k);
    end
    
    if useL
        Lconv = gstMapConv(pFLeft, diagr.H(k, :), diagr.V(k, :), step, 'same');
        if ~exist('Lpos', 'var') || isempty(Lpos)
            [~, Lpos] = max(Lconv);
        end
        Lcalc(k) = Lconv(Lpos);
        Lmult = gstMapMult(pFLeft, diagr.H(k, :), diagr.V(k, :), step, Lpos);
        Lunit(k) = Lcalc(k);
    end
    
    for i= 1:size(pFRight, 1)
        for j = 1:size(pFRight, 2)
            for m = 1:length(Ht1)
                if useR && depthRight(i,j) >= param.dunit && Ht1(m) <= pHLRight(i,j,param.dunit) && pHLRight(i,j,param.dunit) < Ht2(m) && Rmult(i,j) > 0
                    R(k,m) = R(k,m) + Rmult(i,j);
                    cntR(k,m) = cntR(k,m) + 1;
                end
                if useL && depthLeft(i,j) >= param.dunit && Ht1(m) <= pHLLeft(i,j,param.dunit) && pHLLeft(i,j,param.dunit) < Ht2(m) && Lmult(i,j) > 0
                    L(k,m) = L(k,m) + Lmult(i,j);
                    cntL(k,m) = cntL(k,m) + 1;
                end
            end
        end
    end
end

R = R(idxR, :);
cntR = cntR(idxR, :);
Rcalc = Rcalc(idxR);
Runit = Runit(idxR);

L = L(idxL, :);
cntL = cntL(idxL, :);
Lcalc = Lcalc(idxL);
Lunit = Lunit(idxL);

end
