function plotsInfo = reoIterInitPlot3D(npos, nmasks, param, atm, Hc, Tc, freqs, Robs, Lobs)

plotsInfo.npos = npos;
plotsInfo.nmasks = nmasks;
plotsInfo.param = param;
plotsInfo.Hc = Hc;
plotsInfo.Tc = Tc;
plotsInfo.first = true(1, npos);
plotsInfo.freqs = freqs;
plotsInfo.Robs = Robs;
plotsInfo.Lobs = Lobs;

nPlotCol = max(npos, nmasks+1);
npresid = nmasks+1;
nPlotRow = 3;
plotsInfo.hFill = [];
if param.showFill
    nPlotRow = nPlotRow + 1;
end
[hFig, hAxes] = ssuCreateMultiAxesFig(nPlotRow, nPlotCol, '', true, false);
plotsInfo.hFig = hFig;
plotsInfo.hAxes = hAxes;
plotsInfo.hT0 = zeros(1, nmasks);
plotsInfo.atm = [];
if ~isempty(atm) && isfield(atm, 'T')
    plotsInfo.atm = atm;
    for km = 1:nmasks
        plotsInfo.hT0(km) = plot(plotsInfo.hAxes(1,km), atm(km).H, atm(km).T, 'Color', 'g', 'LineWidth', 3);
    end
end
for km = 1:nmasks
    set(plotsInfo.hAxes(1,km), 'XLim', [3e7 3e9], 'XScale', 'log')
    set(plotsInfo.hAxes(1,km), 'YScale', 'log', 'YLim', [1e3 1e7])
    plotsInfo.hAxes(1, km).XLabel.String = 'Height, cm';
    plotsInfo.hAxes(1, km).YLabel.String = 'T, K';
    plotsInfo.hAxes(1, km).Title.String = ['Region ' num2str(km)];
    set(plotsInfo.hAxes(1, km), 'FontSize', param.fontsize);
end
delete(plotsInfo.hAxes(1, (nmasks+2):nPlotCol));
if param.showFill
    set(plotsInfo.hAxes(nPlotRow, 1), 'FontSize', param.fontsize, 'XLim', [3e7 3e9], 'YScale', 'log', 'XScale', 'log');
    delete(plotsInfo.hAxes(nPlotRow, (nmasks+1):nPlotCol));
end

set(plotsInfo.hAxes(1,npresid), 'XLim', [0 param.reslength])
set(plotsInfo.hAxes(1,npresid), 'YScale', 'log', 'YLim', [1e-3 1])
plotsInfo.hAxes(1, npresid).XLabel.String = 'Number of Iterations';
plotsInfo.hAxes(1, npresid).YLabel.String = 'Relative Residual';
set(plotsInfo.hAxes(1, npresid), 'FontSize', param.fontsize);

plotsInfo.hTc = zeros(1, nmasks);
plotsInfo.hRsc = zeros(1, npos);
plotsInfo.hLsc = zeros(1, npos);
for kp = 1:npos
    plotsInfo.hRs0(kp) = plot(plotsInfo.hAxes(2,kp), freqs, Robs(kp,:), 'Color', 'g', 'LineWidth', 3);
    set(plotsInfo.hAxes(2,kp), 'XLim', [3 18]*1e9)
    set(plotsInfo.hAxes(2,kp), 'YLim', [0 max(max(Robs))*1.2])
    plotsInfo.hAxes(2,kp).XLabel.String = 'Frequency, Hz';
    plotsInfo.hAxes(2,kp).YLabel.String = 'Right Max. Flux, s.f.u./arcsec';
    plotsInfo.hAxes(2,kp).Title.String = ['Position ' num2str(kp)];
    set(plotsInfo.hAxes(2,kp), 'FontSize', param.fontsize);
    
    plotsInfo.hLs0(kp) = plot(plotsInfo.hAxes(3,kp), freqs, Lobs(kp,:), 'Color', 'g', 'LineWidth', 3);
    set(plotsInfo.hAxes(3,kp), 'XLim', [3 18]*1e9)
    set(plotsInfo.hAxes(3,kp), 'YLim', [0 max(max(Lobs))*1.2])
    plotsInfo.hAxes(3,kp).XLabel.String = 'Frequency, Hz';
    plotsInfo.hAxes(3,kp).YLabel.String = 'Left Max. Flux, s.f.u./arcsec';
    set(plotsInfo.hAxes(3,kp), 'FontSize', param.fontsize);
end

delete(plotsInfo.hAxes(2, (npos+1):end));
delete(plotsInfo.hAxes(3, (npos+1):end));
drawnow
plotsInfo.cnt0 = 0;

% if param.export
%     l_export(hFig, 0);
%     l_export(hFig, 1);
%     l_export(hFig, 2);
%     l_export(hFig, 3);
%     l_export(hFig, 4);
%     l_export(hFig, 5);
%     l_export(hFig, 6);
%     plotsInfo.cnt0 = 6;
% end

end
