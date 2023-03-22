classdef NMGaussQS < handle
    properties
        srow
        scan
        R
        XSCALE
        freq
        niter = 0
        sqlim = 1e-4
        params
        QSmode
        dmode
        diagrC
        diagrB
        QS
        fixQS = false
        prevQS
        mmode
        baseset
        npeak
        ntail
        ndim
        onedim
        nsimp
        alpha
        minalpha
        hAx = []
        showq = 100
        hPlot
        hPlotC
        hPlotP
    end
    
    methods
        function this = NMGaussQS(srow, scan, R, XSCALE, freq, params, hAx, showq)
            this.srow = srow;
            this.scan = scan;
            this.R = R;
            this.XSCALE = XSCALE;
            this.freq = freq;
            this.params = params;
            if exist('hAx', 'var')
                this.hAx = hAx;
            end
            if exist('showq', 'var')
                this.showq = showq;
            end
        end
        
        function [solution, approx, niter] = process(this, QSmode, dmode, mmode, baseset, prevappr, plotstep, fixQS, c, b)
            global gQS_mode gDiag_mode gDisk_mode

            if ~exist('QSmode', 'var')
                QSmode = gQS_mode.pow4;
            end
            if ~exist('dmode', 'var')
                dmode = gDiag_mode.std;
            end
            if ~exist('mmode', 'var')
                mmode = gDisk_mode.plate;
            end
            if ~exist('baseset', 'var')
                baseset = [];
            end
            if ~exist('prevappr', 'var')
                prevappr = [];
            end
            if exist('plotstep', 'var')
                this.showq = plotstep;
            end
            if exist('fixQS', 'var')
                this.fixQS = fixQS;
            end
            if ~exist('c', 'var')
                c = 0.009;
            end
            if ~exist('b', 'var')
                b = 8.338;
            end
            
            this.QSmode = QSmode;
            this.dmode = dmode;
            this.diagrC = c;
            this.diagrB = b;
            this.mmode = mmode;
            this.ntail = 0;
            if QSmode == gQS_mode.pow4
                this.ntail = 7;
            elseif QSmode == gQS_mode.pow2
                this.ntail = 5;
            elseif QSmode == gQS_mode.qs_amp
                this.ntail = 1;
            end

            if this.ntail > 0 && length(baseset) >= this.ntail
                this.prevQS = baseset(end-this.ntail+1:end);
            end
            
            this.l_qs();
            this.l_baseset(rtnGetDiagrammW(this.freq, this.dmode, this.diagrC, this.diagrB)/2/this.R, this.QS, baseset, prevappr);
            this.npeak = size(this.params, 1);
            this.onedim = 3;
            this.ndim = this.npeak*this.onedim + this.ntail;
            assert(this.ndim == length(this.baseset))
            this.nsimp = this.ndim+1;
            
            simplex = this.l_simplex();
            
            if ~isempty(this.hAx)
                s = this.calcscan(this.baseset);
                plot(this.hAx, this.srow, s, 'LineWidth', 2);
                mm = max(this.scan);
                %set(this.hAx, 'YLim', [-mm*0.1 mm*1.2]);
                plot(this.hAx, this.srow, this.QS, 'LineWidth', 2);
            end
            
            this.hPlot = [];
            this.hPlotC = [];
            this.hPlotP = [];

            this.niter = 0;
            [solution, this.niter] = NelderMead(@l_calc, @l_crit, @l_bound, simplex, 1, 2, 0.5, 0.5);
            approx = this.calcscan(solution);
            niter = this.niter;
            
            function x = l_bound(x)
                x = this.l_bound_par(x);
            end

            function f = l_calc(x)
                s = this.calcscan(x);
                f = sum((this.scan - s).^2);
                this.niter = this.niter + 1;
                
                if ~isempty(this.hAx) && mod(this.niter, this.showq) == 0 && this.npeak > 0
                    if ~isempty(this.hPlot)
                        delete(this.hPlot);
                    end   
                    if ~isempty(this.hPlotC)
                        delete(this.hPlotC);
                    end   
                    if ~isempty(this.hPlotP)
                        delete(this.hPlotP);
                    end   
                    this.hPlot = plot(this.hAx, this.srow, s, 'Color', 'r');
                    xc = x(3:3:3*this.npeak);
                    amp = x(1:3:3*this.npeak);
                    mc = 'r';
                    ms = 5;
                    this.hPlotC = plot(this.hAx, xc, amp/max(amp)*min(this.QS), 'LineStyle', 'None', 'Marker', 'o', 'MarkerEdgeColor', mc, 'MarkerFaceColor', mc, 'MarkerSize', ms);
                    if this.npeak > 1
                        xcpos = x(3*this.npeak);
                        this.hPlotP = plot(this.hAx, [xcpos xcpos], [0 1.2], 'Color', 'k');
                    end
                    drawnow
                end
            end

            function conv = l_crit(x, f)
                %conv = all(std(x(:, 1:end-7), 0, 1)./mean(x(:, 1:end-7), 1) < 1e-3) && (all(std(f, 0)./mean(f) < 1e-3) || all(f < 1e-6));
                %conv = all(std(x(:, 1:end-7), 0, 1)./mean(x(:, 1:end-7), 1) < 1e-1) && (all(std(f, 0)./mean(f) < 1e-1) || all(f < 1e-6));
                conv = all(std(x(:, 1:end-7), 0, 1)./mean(x(:, 1:end-7), 1) < 5e-2) && (all(std(f, 0)./mean(f) < 5e-2) || all(f < 1e-6));
            end
        end
        
        function s = calcscan(this, x, qmode)
            global gQS_mode

            calcpeaks = true;
            if ~exist('qmode', 'var')
                qmode = this.QSmode;
            elseif qmode == gQS_mode.qs_only
                qmode = this.QSmode;
                calcpeaks = false;
            end
            s = zeros(1, length(this.srow));
            if calcpeaks
                for kd = 1:this.npeak
                    idx = (kd-1)*this.onedim + 1;
                    s = s + x(idx)*exp(-x(idx+1).*(x(idx+2)-this.srow).^2);
                end
            end
            
            if qmode == gQS_mode.pow4
                s = s + x(end-6) + x(end-5)*exp(x(end-3).*(x(end-4)-this.srow).^2+x(end-2).*(x(end-4)-this.srow).^4) ...
                                   .*sqrt(1-x(end-1).*(x(end-4)-this.srow).^2-x(end).*(x(end-4)-this.srow).^4);
            elseif qmode == gQS_mode.pow2
                s = s + x(end-4) + x(end-3)*exp(x(end-1).*(x(end-2)-this.srow).^2) ...
                                   .*sqrt(1-x(end).*(x(end-2)-this.srow).^2);
            elseif qmode == gQS_mode.qs_amp
                s = s + x(end)*this.QS;
            elseif qmode == gQS_mode.qs_ampcen
                
                s = s + x(end)*this.QS;
            end

            s(imag(s) ~= 0) = 0;
        end
        
        %__________________________________________________________________
        function l_qs(this)
            [qs, arcsecs] = reuQuietSun(this.freq, this.R, this.XSCALE, this.dmode, this.mmode, this.diagrC, this.diagrB);
            this.QS = interp1(arcsecs/this.R, qs, this.srow);
            this.QS(this.QS < 1e-7) = 1e-7;

            [~, im] = min(this.scan./this.QS);
            this.QS = this.QS/this.QS(im)*this.scan(im);
        end
        
        function l_baseset(this, dw2, QS, baseset0, prevappr)
            global gQS_mode

            n0 = length(baseset0);
            np0 = 0;
            if n0 > 0
                np0 = n0 - this.ntail;
            end

            this.baseset = zeros(1, size(this.params,1)*3 + this.ntail);
            this.baseset(1:np0) = baseset0(1:np0);
            this.alpha = log(2)/dw2^2;
            this.minalpha = log(2)/(dw2+0.1)^2;
            for k = (np0/3+1):size(this.params, 1)
                this.baseset(3*(k-1)+1) = abs(interp1(this.srow, this.scan-pick(~isempty(prevappr), prevappr, QS), this.params(k,1)));
                this.baseset(3*(k-1)+2) = this.alpha;
                this.baseset(3*(k-1)+3) = this.params(k,1);
            end

            [~, im] = min(abs(this.srow));

            if this.QSmode == gQS_mode.pow4
                if n0 >= 7
                    this.baseset(end-6:end) = baseset0(end-6:end);
                else
                    this.baseset(end-6) = -QS(im)*0.1;
                    this.baseset(end-5) = QS(im)-this.baseset(end-6);
                    this.baseset(end-4) = 1e-5;
                    this.baseset(end-3) = 0.32;
                    this.baseset(end-2) = 0.12;
                    this.baseset(end-1) = 1.05;
                    this.baseset(end  ) = -0.02;
                end
            elseif this.QSmode == gQS_mode.pow2
                if n0 >= 5
                    this.baseset(end-4:end) = baseset0(end-4:end);
                else
                    this.baseset(end-4) = -QS(im)*0.1;
                    this.baseset(end-3) = QS(im)-this.baseset(end-4);
                    this.baseset(end-2) = 1e-5;
                    this.baseset(end-1) = 0.32;
                    this.baseset(end) = 1.05;
                end
            elseif this.QSmode == gQS_mode.qs_amp
                if n0 >= 1
                    this.baseset(end) = baseset0(end);
                else
                    this.baseset(end) = max(this.QS);
                end
            elseif this.QSmode == gQS_mode.qs_ampcen
                if n0 >= 2
                    this.baseset(end-1:end) = baseset0(end-1:end);
                else
                    this.baseset(end-1) = max(this.QS);
                    this.baseset(end) = 0;
                end
            end
        end
        
        function simplex = l_simplex(this)
            simplex = zeros(this.nsimp, this.ndim);
            for ksimp = 1:this.nsimp
                simplex(ksimp, :) = this.baseset + (rand(1, this.ndim)-0.5)*2 .*this.baseset.* 0.1;
            end
        end
        
        function x = l_bound_par(this, x)
            for kd = 1:this.npeak
                idx = (kd-1)*this.onedim + 1;
                x(idx) = pick(x(idx) <= 0, 0.01, x(idx));
                x(idx+1) = pick(x(idx+1) <= this.minalpha, this.minalpha, x(idx+1));
                x(idx+1) = pick(x(idx+1) > this.alpha*1.1, this.alpha*1.1, x(idx+1));
                x(idx+2) = pick(abs(x(idx+2)-this.baseset(idx+2)) > this.params(kd, 2), this.baseset(idx+2)+pick(x(idx+2) > this.baseset(idx+2), 1, -1)*this.params(kd, 2), x(idx+2));
            end
            
            if this.ntail > 0
                if ~this.fixQS
                    ss = calcscan(this, x, 99);
                    ddss = diff(sign(diff(ss)));
                    dm = min(this.scan./ss);
                    nomove = false;
                    if length(find(ddss)) > 1 && ~isempty(this.prevQS)
                        nomove = true;
                    elseif dm < 0.97
                        nomove = true;
                    else
                        ss = ss/max(ss)*max(this.QS);
                        if max(abs(ss-this.QS)./this.QS) > 0.04
                            nomove = true;
                        end
                    end
                    if nomove
                        x(end-this.ntail+1:end) = this.prevQS(end-this.ntail+1:end);
                    end
                    this.prevQS(end-this.ntail+1:end) = x(end-this.ntail+1:end);
                end
            end
%                 else
%                     ss = ss*max(this.QS)/max(ss);
%                     sqs = ss./this.QS;
%                     if (max(sqs) > 1.15 || min(sqs) < 1/1.15) && ~isempty(gNelderMedXR)
%                         x(end-this.ntail+1:end) = gNelderMedXR(end-this.ntail+1:end);
%                     elseif this.QSmode == gQS_mode.pow4
%                         k = max(ss)/min(ss);
%                         if k < 1.7
%                             a = x(end-6);
%                             b = x(end-5);
%                             k = -0.5*a/b/((max(ss)-min(ss))/b - 0.5);
%                             x(end-5) = x(end-5)*k;
%                         end
%                     end
%                 end
%             end
            
        end
    end
end
