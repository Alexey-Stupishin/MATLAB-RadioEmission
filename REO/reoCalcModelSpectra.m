function [Robs, Lobs, rescalc] = reoCalcModelSpectra(hLib, freqs, M, step, base, param, pos, atm)

rescalc = [];
Robs = zeros(length(pos), length(freqs));
Lobs = zeros(length(pos), length(freqs));

[diagr.H, diagr.V] =  mfoCreateRATANDiagrams(freqs, M, [step step], base, 3);
for kf = 1:length(freqs)
    pFRightW = zeros(M(1), M(2));
    pFLeftW = zeros(M(1), M(2));
    for km = 1:length(atm)
        [depthRight, pFRight, pTauRight, pHLRight, pFLRight, psLRight, ...
         depthLeft, pFLeft, pTauLeft, pHLLeft, pFLLeft, psLLeft, ...
         scanR, scanL] = ...
            reoCalculate(hLib, atm(km).H, atm(km).T, atm(km).D, freqs(kf), param.harms, param.pTauL, atm(km).mask);
        
        pFRightW = pFRightW + pFRight;
        pFLeftW = pFLeftW + pFLeft;
    end
    
    scanR = gstMapConv(pFRightW, diagr.H(kf, :), diagr.V(kf, :), step, 'same');
    scanL = gstMapConv(pFLeftW, diagr.H(kf, :), diagr.V(kf, :), step, 'same');
    
    %rescalc = [rescalc struct('freq', freqs(kf), 'fluxR', pFRightW, 'fluxL', pFLeftW, 'scanR', scanR, 'scanL', scanL)];
    
    for kp = 1:length(pos)
        vR = gstMapMult(pFRightW, diagr.H(kf, :), diagr.V(kf, :), step, pos(kp));
        vL = gstMapMult(pFLeftW, diagr.H(kf, :), diagr.V(kf, :), step, pos(kp));
        Robs(kp, kf) = xsum2(vR);
        Lobs(kp, kf) = xsum2(vL);
    end
end

end
