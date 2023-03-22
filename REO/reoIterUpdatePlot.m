function plotsInfo = reoIterUpdatePlot(plotsInfo, Hcalc, Tcalc, Rcalc, Lcalc, Rcnt, Lcnt, resRv, resLv, cntNT, x)
    
    for km = 1:plotsInfo.nmasks
        Hmodel = [];
        Tmodel = [];
        if ~isempty(plotsInfo.atm)
            Hmodel = plotsInfo.atm(km).H;
            Tmodel = plotsInfo.atm(km).T;
        end
        [plotsInfo.hT0(km), plotsInfo.hTc(km)] = l_updatePlot(plotsInfo.hAxes(1, km), plotsInfo.hT0(km), plotsInfo.hTc(km), Hmodel, Tmodel, Hcalc, Tcalc(km,:), 'm', plotsInfo.Tc(km,:));
    end
    for kp = 1:plotsInfo.npos
        [plotsInfo.hRs0(kp), hRscc] = l_updatePlot(plotsInfo.hAxes(2, kp), plotsInfo.hRs0(kp), plotsInfo.hRsc(kp), plotsInfo.freqs, plotsInfo.Robs(kp,:), plotsInfo.freqs, Rcalc(kp,:), 'r', [], plotsInfo.first(kp));
        [plotsInfo.hLs0(kp), hLscc] = l_updatePlot(plotsInfo.hAxes(3, kp), plotsInfo.hLs0(kp), plotsInfo.hLsc(kp), plotsInfo.freqs, plotsInfo.Lobs(kp,:), plotsInfo.freqs, Lcalc(kp,:), 'r', [], plotsInfo.first(kp));
        plotsInfo.first(kp) = plotsInfo.hRsc(kp) == 0;
        plotsInfo.hRsc(kp) = hRscc;
        plotsInfo.hLsc(kp) = hLscc;
    end

    lr = length(resRv);
    if lr > 1
        plot(plotsInfo.hAxes(1, plotsInfo.nmasks+1), [lr-1 lr], resRv(end-1:end), 'Color', 'r')
        plot(plotsInfo.hAxes(1, plotsInfo.nmasks+1), [lr-1 lr], resLv(end-1:end), 'Color', 'b')
        plot(plotsInfo.hAxes(1, plotsInfo.nmasks+1), [lr-1 lr], resRv(end-1:end)+resLv(end-1:end), 'Color', 'k')
    end
    if plotsInfo.param.showFill
        if ~isempty(plotsInfo.hFill)
            delete(plotsInfo.hFill);
        end
        plotsInfo.hFill = [];
        for km = 1:plotsInfo.nmasks
            for kp = 1:plotsInfo.npos
                Rc = xsumrem(Rcnt, [2 5]);
                Lc = xsumrem(Lcnt, [2 5]);
                hR = plot(plotsInfo.hAxes(4, km), Hcalc, Rc(kp, :, km), 'Color', 'r'); hold on
                hL = plot(plotsInfo.hAxes(4, km), Hcalc, Lc(kp, :, km), 'Color', 'b'); hold on
                plotsInfo.hFill = [plotsInfo.hFill hR hL];
            end
        end
        cla(plotsInfo.hAxes(4, plotsInfo.npos+1));
        for km = 1:plotsInfo.nmasks
            plot(plotsInfo.hAxes(4, plotsInfo.npos+1), Hcalc, x(km, :).', 'Color', 'k'); hold on
        end
    end
    drawnow

    %pos, freq, height, mask, harm
    
%     if plotsInfo.param.export
%         l_export(plotsInfo.hFig, cntNT+plotsInfo.cnt0);
%     end

end

%--------------------------------------------------------------------------
function [h0, hc] = l_updatePlot(hAx, h0, hc, x0, y0, xc, yc, color, init, first)

if ~isempty(h0) && h0 ~= 0
    delete(h0);
end
if ~isempty(hc) && hc ~= 0
    if exist('first', 'var') && first
        set(hc, 'color', [0 0 0])
    else
        set(hc, 'color', [0.6 0.6 0.6], 'LineWidth', 1)
    end
end
if exist('init', 'var') && ~isempty(init)
    plot(hAx, xc, init, 'Color', 'k', 'LineWidth', 2);
end
if ~isempty(h0) && h0 ~= 0
    h0 = plot(hAx, x0, y0, 'Color', 'g', 'LineWidth', 4);
end
hc = plot(hAx, xc, yc, 'Color', color, 'LineWidth', 3);

end

%--------------------------------------------------------------------------
function l_output(Hcalc, Tcalc, Ncalc, outfile, NT)

outbase = [outfile '_' strrep(strtrim(num2str(NT, '%9.2e')), '+', '')];

M = [Hcalc' Tcalc' Ncalc'];
dlmwrite([outbase '.dat'], M, 'delimiter', ' ', 'precision', '%10.3e');

H = Hcalc';
Temp = Tcalc';
Dens = Ncalc';

iouData2SAV([outbase '.sav'], 'H', 'Temp', 'Dens');

end

%--------------------------------------------------------------------------
function l_export(hFig, n)

hgexport(hFig, fullfile('c:\temp\NewIter', ['iter_' sprintf('%05d', n) '.png']), hgexport('factorystyle'), 'Format', 'png');

end
