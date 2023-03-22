function [Tcalc, Dcalc] = reoIterationCoreMultiFix(hLib, Mmap, freqs, Robs, Lobs, WR, WL, Hfixed, Tfixed, Ht1, Ht2, Hc, Tc, NTv, masks, posR, posL, step, diagr, param, plotsInfo, plotFunc)

% Robs, Lobs: npos x nfreqs
% pos*: 1 x npos
% Hmodel, Tmodel: nmasks x nheight_model
% Hbase: 1 x nheight_base
% Tbase: nmasks x nheight_base
% Hc: 1 x nheight_var
% Tc: nmasks x nheight_var
% masks(n).mask

Tcalc = zeros(size(Tc));
Dcalc = zeros(size(Tc));

npos = length(posR);
nmasks = length(masks);
nfreqs = length(freqs);
nheights = size(Hc, 2);

nNT = 1;
NT = NTv(:, nNT);

outCntres = zeros(size(NTv, 2));
outCntNT = zeros(size(NTv, 2));
outRes = zeros(size(NTv, 2));

ticID = tic;

resRv = [];
resLv = [];
Tprev = Tc;
%Tinit = Tc;
relax = param.relax;
cntres = 0;
cntNT = 0;
resprev = 0;
x = ones(nmasks, nheights);
while true    
    Hcalc = Hc;
    for km = 1:nmasks
        Tc(km, :) = x(km, :).*Tc(km, :);
        if cntNT > param.relaxStart % && cntNT < 12
            Tc(km, :) = exp(relax*log(Tc(km, :)) + (1-relax)*log(Tprev(km, :)));
        end
        %Tcm = Tc(km, :);
        %Tcm(Hfixed(km, :)) = Inf;
        %[~, im] = min(Tcm(end:-1:1));
        %im = length(Tcm) - im;
        Tcx = Tc(km, :);
        %Tcx(1:im) = param.Tmin;
        Tcx(Tcx < param.Tmin) = param.Tmin;
        Tc(km, :) = Tcx;
        Tprev(km, :) = Tc(km, :);
    
        Tcalc(km, :) = Tc(km, :);
        Tcalc(km, Hfixed(km, :)) = Tfixed(km, Hfixed(km, :));
        Dcalc(km, :) = l_barometric(Hcalc, Tcalc(km, :), NT(km), param);
    end
    
    Rcalc = zeros(npos, nfreqs);
    Lcalc = zeros(npos, nfreqs);
    R = zeros(npos, nfreqs, nheights, nmasks, max(param.harms)+1);
    L = zeros(npos, nfreqs, nheights, nmasks, max(param.harms)+1);
    Rcnt = zeros(npos, nfreqs, nheights, nmasks, max(param.harms)+1);
    Lcnt = zeros(npos, nfreqs, nheights, nmasks, max(param.harms)+1);
    
    for kf = 1:length(freqs)
        tfR = zeros(Mmap);
        tfL = zeros(Mmap);
        tfwR = zeros(Mmap);
        tfwL = zeros(Mmap);
        thR = zeros(Mmap(1), Mmap(2), nmasks);
        thL = zeros(Mmap(1), Mmap(2), nmasks);
        tsR = zeros(Mmap(1), Mmap(2), nmasks);
        tsL = zeros(Mmap(1), Mmap(2), nmasks);
        for km = 1:nmasks
            [depthRight, pFRight, pTauRight, pHLRight, pFLRight, psLRight, ...
             depthLeft, pFLeft, pTauLeft, pHLLeft, pFLLeft, psLLeft] = ...
                     reoCalculate(hLib, Hcalc, Tcalc(km, :), Dcalc(km, :), freqs(kf), param.harms, param.pTauL, masks(km).mask, true);

            [tfwRm, tfRm] = l_give4mask(masks(km).mask, pFRight, pFLRight, psLRight, pFFF, param);
            tfwR = tfwR + tfwRm;
            tfR = tfR + tfRm;
            thR(:,:,km) = pHLRight(:,:,param.dunit);
            tsR(:,:,km) = psLRight(:,:,param.dunit)+1;
            
            [tfwLm, tfLm] = l_give4mask(masks(km).mask, pFLeft, pFLLeft, psLLeft, pFFF, param);
            tfwL = tfwL + tfwLm;
            tfL = tfL + tfLm;
            thL(:,:,km) = pHLLeft(:,:,param.dunit);
            tsL(:,:,km) = psLLeft(:,:,param.dunit)+1;
        end
%         [scanR, flux] = gstMapConv(tfwR, diagr.H(kf, :), diagr.V(kf, :), step);
%         [scanL, flux] = gstMapConv(tfwL, diagr.H(kf, :), diagr.V(kf, :), step);
        for kp = 1:npos
            vR = gstMapMult(tfR, diagr.H(kf, :), diagr.V(kf, :), step, posR(kp));
            vL = gstMapMult(tfL, diagr.H(kf, :), diagr.V(kf, :), step, posL(kp));
            
            Rcalc(kp, kf) = sum(sum(gstMapMult(tfwR, diagr.H(kf, :), diagr.V(kf, :), step, posR(kp))));
            Lcalc(kp, kf) = sum(sum(gstMapMult(tfwL, diagr.H(kf, :), diagr.V(kf, :), step, posL(kp))));
            
            for km = 1:nmasks
                for i = 1:size(vR, 1)
                    for j = 1:size(vR, 2)
                        if masks(km).mask(i,j)
                            for kh = 1:nheights
                                if Ht1(kh) <= thR(i,j,km) && thR(i,j,km) < Ht2(kh) && vR(i,j) ~= 0
                                    R(kp,kf,kh,km,tsR(i,j,km)) = R(kp,kf,kh,km,tsR(i,j,km)) + vR(i,j);
                                    if ~Hfixed(km, kh)
                                        Rcnt(kp, kf, kh, km, tsR(i,j,km)) = Rcnt(kp, kf, kh, km, tsR(i,j,km)) + 1;
                                    end
                                end
                                if Ht1(kh) <= thL(i,j,km) && thL(i,j,km) < Ht2(kh) && vL(i,j) ~= 0
                                    L(kp,kf,kh,km,tsL(i,j,km)) = L(kp,kf,kh,km,tsL(i,j,km)) + vL(i,j);
                                    if ~Hfixed(km, kh)
                                        Lcnt(kp, kf, kh, km, tsL(i,j,km)) = Lcnt(kp, kf, kh, km, tsL(i,j,km)) + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    resR = sqrt(sum(sum((Robs-Rcalc).^2)));
    resRrel = resR/sum(sum(Robs));
    resL = sqrt(sum(sum((Lobs-Lcalc).^2)));
    resLrel = resL/sum(sum(Lobs));
    resRv = [resRv resRrel];
    resLv = [resLv resLrel];
    resS = resRrel + resLrel;
    if abs(resS - resprev)/resS < param.reslim
        cntres = cntres + 1;
    else
        cntres = 0;
    end
    if cntres >= param.rescntstab || cntNT >= param.rescntmax
        disp(['*CNT=' num2str(nNT) ' cntStable=' num2str(cntres) ' cntNT=' num2str(cntNT) ' res=' num2str(resS) ' t=' srvSecToDisp(toc(ticID))]);
        outCntres(nNT) = cntres;
        outCntNT(nNT) = cntNT;
        outRes(nNT) = resS;
        
        if nNT >= size(NTv, 2)
            break
        end
        nNT = nNT + 1;
        NT = NTv(:, nNT);
        cntres = 0;
        cntNT = 0;
        ticID = tic;
    end
    resprev = resS;
    cntNT = cntNT + 1;
    disp(['  cntStable=' num2str(cntres) ' cntNT=' num2str(cntNT) ' res=' num2str(resS) ' t=' srvSecToDisp(toc(ticID))]);
    if cntNT == 1
        disp(num2str(xsumrem(Rcnt, [2 3 5])))
        disp(num2str(xsumrem(Lcnt, [2 3 5])))
    end
    
    plotsInfo = feval(plotFunc, plotsInfo, Hcalc, Tcalc, Rcalc, Lcalc, Rcnt, Lcnt, resRv, resLv, cntNT);
    
    ncols = 0;
    colPos = zeros(1, nmasks*nheights);
    ncolsm = zeros(1, nmasks);
    for km = 1:nmasks
        for kh = 1:nheights
            if ~Hfixed(km, kh)
                ncolsm(km) = ncolsm(km) + 1;
                ncols = ncols + 1;
                colPos(kh+(km-1)*nheights) = ncols;
            end
        end
    end
    
    Mall = zeros(2*nfreqs*npos, ncols);
    Fall = zeros(2*nfreqs*npos, 1);
    Wall = ones(2*nfreqs*npos, 1);
    
    for mode = 1:2
        if mode == 1
            V = sum(R, 5);
            Vo = Robs;
            Vc = Rcalc;
            Vw = param.wR;
            Vi = WR;
        else
            V = sum(L, 5);
            Vo = Lobs;
            Vc = Lcalc;
            Vw = param.wL;
            Vi = WL;
        end
        for kp = 1:npos
            for kf = 1:nfreqs
                row = kf+((kp-1)+(mode-1)*nfreqs)*npos;
                fixed = 0;
                for km = 1:nmasks
                    for kh = 1:nheights
                        if colPos(kh+(km-1)*nheights) == 0
                            fixed = fixed + V(kp,kf,kh,km);
                        else
                            Mall(row, colPos(kh+(km-1)*nheights)) = V(kp,kf,kh,km);
                        end
                    end
                end
                thick = sum(Mall(row, :));
                thin = (Vc(kp, kf) - thick);
                Fall(row) = Vo(kp, kf) - thin - fixed;
                Wall(row) = param.wFreq*Vw*Vi(kp, kf);
            end
        end
    end
    
    sm = sum(sum(Mall))/numel(Mall(Mall > 0));
    
    cnt = 0;
    FT = zeros(ncols, 1);
    TM = zeros(ncols, ncols);
    WT = ones(ncols, 1);
    if length(param.wTemp) == 1
        WT = WT*param.wTemp;
    end
    for km = 1:nmasks
        for kh = 2:nheights
            pos = kh+(km-1)*nheights;
            if colPos(pos) ~= 0
                cnt = cnt + 1;
                if length(param.wTemp) > 1
                    WT(cnt) = param.wTemp(kh); 
                end
                cp = colPos(pos);
                if colPos(pos-1) ~= 0 % colPos(pos-1) == cp-1
                    TM(cnt, cp-1:cp) = [Tc(km, kh-1) -Tc(km, kh)];
                else
                    TM(cnt, cp) = Tc(km, kh);
                    FT(cnt) = Tfixed(km, kh-1);
                end
            else
                if colPos(pos-1) ~= 0
                    cnt = cnt + 1;
                    if length(param.wTemp) > 1
                        WT(cnt) = param.wTemp(kh); 
                    end
                    TM(cnt, colPos(pos-1)) = Tc(km, kh-1);
                    FT(cnt) = Tfixed(km, kh);
                end
            end
        end
    end
    TM = TM*sm*1e-6;
    FT = FT*sm*1e-6;

    Mall = [Mall; TM];
    Fall = [Fall; FT];
    Wall = [Wall; WT];

%     E = zeros(nheights, nheights, nmasks);
%     Z = zeros(nheights, nheights);
%     for km = 1:nmasks
%         E(:, :, km) = diag(Tc(km, :));
%     end
%     
%     DF = zeros(nheights, 1);
%     DW = ones(nheights, 1)*param.wCross;
%     for km = 1:nmasks-1
%         Mall = [Mall; repmat(Z, [1 km-1]) E(:,:,km) -E(:,:,km+1) repmat(Z, [1 nmasks-km-1])];
%         Fall = [Fall; DF];
%         Wall = [Wall; DW];
%     end
    
    for kh = size(Mall,1):-1:1
        if all(Mall(kh, :) == 0) || Wall(kh) == 0
            Mall(kh, :) = [];
            Fall(kh) = [];
            Wall(kh) = [];
        end
    end
    
    xx = lscov(Mall, Fall, Wall);
    xx = min(param.expMax, max(xx, param.expMin));

    x = ones(nmasks, nheights);
    for km = 1:nmasks
        for kh = 1:nheights
            if colPos(kh+(km-1)*nheights) ~= 0
                x(km, kh) = xx(colPos(kh+(km-1)*nheights));
            end
        end
    end

    relax = param.relax;
end

end

%--------------------------------------------------------------------------
function Dcalc = l_barometric(Hcalc, Tcalc, NT, param)

if ~param.barometric
    Dcalc = NT./Tcalc;
    if isfield(param, 'Dfactor')
        Dcalc = Dcalc.*param.Dfactor;
    end
else
    NTx = NT*ones(1, length(Tcalc));
    
    idx = find(Tcalc > 3e5);
    if ~isempty(idx)
        H0 = Hcalc(idx(1));
        NTx(idx(1):end) = NT*exp(-(Hcalc(idx(1):end)-H0)/4.5e3./Tcalc(idx(1):end));
    end
    
    Dcalc = NTx./Tcalc;
end

end

%--------------------------------------------------------------------------
function [tfw, tf] = l_give4mask(mask, pF, pFL, ~, ~, param)

tfw = pF;
tfw(~mask) = 0;
tf = pFL(:,:,param.dunit);
tf(~mask) = 0;

end

% %--------------------------------------------------------------------------
% function [use, useFF] = l_checkUse(mask, ps, param)
% 
% p = sum(ps(:, :, 1:param.dunit), 3);
% use = mask & p > 0;
% % useFF = mask & sum(ps, 3) == 0;
% useFF = false(size(mask));
% 
% end
% 
% %--------------------------------------------------------------------------
% function [tfw, tf] = l_give4mask(mask, pF, pFL, psL, pFFF, param)
% 
% [use, useFF] = l_checkUse(mask, psL, param);
% tfw = pF;
% tfw(~use) = 0;
% t = pF;
% t(~useFF) = 0;
% t(useFF) = t(useFF)-pFFF;
% tfw = tfw + t;
% tf = pFL(:,:,param.dunit);
% tf(~use) = 0;
% t = pFL(:,:,param.dunit);
% t(~useFF) = 0;
% t(useFF) = t(useFF)-pFFF;
% tf = tf + t;
% 
% end
