function [Robs, Lobs, rescalc] = reoCalcModelSpectraByAtm(hLib, freqs, M, calc_mask, step, base, harms, pos)

rescalc = [];
Robs = zeros(length(pos), length(freqs));
Lobs = zeros(length(pos), length(freqs));

[diagr.H, diagr.V] =  mfoCreateRATANDiagrams(freqs, M, [step step], base, 3);
for kf = 1:length(freqs)
    [depthRight, pFRightW, pTauRight, pHLRight, pFLRight, psLRight, ...
     depthLeft, pFLeftW, pTauLeft, pHLLeft, pFLLeft, psLLeft] = ...
        gstCalcMapByAtm(hLib, calc_mask, freqs(kf), harms, 100);
    
    %xsurf(pFRightW)
    
%     scanR = gstMapConv(pFRightW, diagr.H(kf, :), diagr.V(kf, :), step, 'same');
%     scanL = gstMapConv(pFLeftW, diagr.H(kf, :), diagr.V(kf, :), step, 'same');
    
    %rescalc = [rescalc struct('freq', freqs(kf), 'fluxR', pFRightW, 'fluxL', pFLeftW, 'scanR', scanR, 'scanL', scanL)];
    
    for kp = 1:length(pos)
        vR = gstMapMult(pFRightW, diagr.H(kf, :), diagr.V(kf, :), step, pos(kp));
        vL = gstMapMult(pFLeftW, diagr.H(kf, :), diagr.V(kf, :), step, pos(kp));
        Robs(kp, kf) = xsum2(vR);
        Lobs(kp, kf) = xsum2(vL);
    end
end

end
