function [resT, M, Fr, w, incl] = reoIterationSolve(freqs, idxR, idxL, R, L, Robs, Lobs, Runit, Lunit, Tc, param)

M = [R; L];
Fobs = [Robs Lobs];
Funit = [Runit Lunit];
freqs = [freqs(idxR), freqs(idxL)];
w = param.wFreq*[param.wR param.wL];

Fr = zeros(1, length(Fobs));
incl = true(1, length(freqs));
for i = 1:length(freqs)
    thin = Funit(i) - sum(M(i, :));
    if Fobs(i) < param.fluxLim*max(Fobs)
        incl(i) = false;
    elseif all(M(i, :) == 0)
        incl(i) = false;
    else
        v = thin/Funit(i); 
        if v > param.thinLim
            incl(i) = false;
        else
            w(i) = w(i)*(1-v/param.thinLim)^param.thinPow;
        end
    end
    
    if incl(i)
        Fr(i) = Fobs(i) - thin;
        for h = 1:size(M, 2)
            if M(i, h) < param.useLim*Funit(i)
                Fr(i) = Fr(i) - M(i, h);
                M(i, h) = 0;
            end
        end
        Fr(i) = max([Fr(i) 0]);
    end
end

Fobs = Fobs(incl);
freqs = freqs(incl);

M = M(incl, :);
Fr = Fr(incl);
w = w(incl);
nEqF = size(M, 1);

if param.wTemp > 0
    sm = sum(sum(M))/numel(M(M > 0))*1e-6;
    Z = zeros(length(Tc)-1, length(Tc));
    for i = 1:length(Tc)-1
        Z(i, i:i+1) = [Tc(i) -Tc(i+1)]*sm;
    end
    M = [M; Z];
    Fr = [Fr, zeros(1, size(Z, 1))];
    w = [w ones(1, size(Z, 1))*param.wTemp];
end

if isfield(param, 'solve_mode') && strcmp(param.solve_mode, 'NM')
    nEqT = length(Tc)-1;
    resT = reoFindCorrection(M, Fr, Tc, nEqF, nEqT, param.wTemp);
else
    x = lscov(M, Fr', w');
    x = min(param.expMax, max(x, param.expMin));
    resT = x';
end

end
