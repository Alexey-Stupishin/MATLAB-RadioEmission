function x = reoNM(hLib, Robs, Lobs, Hb, Tb, Hc, Tc, NT, Ht1, Ht2, freqs, harms, pTauL, diagr, step, hAxes, hFig, plots, H0, T0)

Tc0 = Tc;

n = length(Tc);
initsimp = ones(n+1, n);
for k = 1:n+1
    initsimp(k, :) = Tc;
    if k <= n
        initsimp(k, k) = initsimp(k, k) * 10;
    end
end

Rcalc = zeros(size(Robs));
Lcalc = zeros(size(Lobs));
resd = [];
cnt = 1;

x = NelderMead(@l_calc, @l_crit, @l_bound, initsimp, 1, 2, 0.5, 0.5, @l_report);

    function x = l_bound(x)
        for i = 1:n
            if x(i) < 6000
                x(i) = 6000;
            elseif x(i) > 1e8
                x(i) = 1e8;
            end
        end
    end

    function f = l_calc(x)
        [~, ~, Rcalc, Lcalc] = reoIterationCalcStep(hLib, Hb, Tb, Hc, x, NT, Ht1, Ht2, freqs, harms, pTauL, diagr, step);
        resR = sqrt(sum((Robs-Rcalc).^2));
        resRrel = resR/sum(Robs);
        resL = sqrt(sum((Lobs-Lcalc).^2));
        resLrel = resL/sum(Lobs);
        f = resRrel + resLrel;
    end

    function l_report(x)
        plot(hAxes(1, 1), Hc, Tc0, 'Color', 'k');
        [plots.hT0, plots.hTc] = l_updatePlot(hAxes(1, 1), plots.hT0, plots.hTc, H0, T0, Hc, x, 'm');
        [plots.hRs0, plots.hRsc] = l_updatePlot(hAxes(2, 1), plots.hRs0, plots.hRsc, freqs, Robs, freqs, Rcalc, 'r');
        [plots.hLs0, plots.hLsc] = l_updatePlot(hAxes(2, 2), plots.hLs0, plots.hLsc, freqs, Lobs, freqs, Lcalc, 'b');
        resd = [resd l_calc(x)];
        plot(hAxes(1,2), resd, 'Color', 'k')
        drawnow
        hgexport(hFig, ['s:\University\Work\NewIterations\NMprot\' num2str(cnt, '%06d') '.png'], hgexport('factorystyle'), 'Format', 'png');
        cnt = cnt + 1;
    end

    function conv = l_crit(x, ~)
        conv = all(std(x, 0, 1)./mean(x(:, 1), 1) < 1e-8);
    end

end

%--------------------------------------------------------------------------
function [h0, hc] = l_updatePlot(hAx, h0, hc, x0, y0, xc, yc, color)

if ~isempty(h0)
    delete(h0);
end
if ~isempty(hc)
    set(hc, 'color', [0.9 0.9 0.9])
end
if ~isempty(h0)
    h0 = plot(hAx, x0, y0, 'Color', 'g', 'LineWidth', 4);
end
hc = plot(hAx, xc, yc, 'Color', color, 'LineWidth', 2);

end

