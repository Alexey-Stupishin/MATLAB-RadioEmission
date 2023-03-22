function rtuMultiGauss(infits, freqs)

global gQS_mode gDiag_mode gDisk_mode

wing = 1.0;
wdraw = 1.2;
% mainmode = gQS_mode.qs_ampcen;
% switchlim = -1;
nhist = 50;
cntlim = 150;
chi2n = 20;
chi2dd = 6.3e-3;
res2dd = 2.5e-4;

reuApprInit();

ratan = iouLoadFitsRATAN(infits);

[inpath, inname] = fileparts(infits);
prefix = srvStr2Filename([inpath '_' inname]);
stamp = srvTimeStamp();

fdirall = ['d:\UData\RATAN\NMQS\' prefix '_all_' stamp];
mkdir(fdirall);

to_save = [];
for k = 1:length(freqs)
    freq = freqs(k);
    hw = rtnGetDiagrammW(freq*1e9, 3);
    dm = hw/2/ratan.SOLAR_R;

    fdir = ['d:\UData\RATAN\NMQS\' prefix '_' num2str(freq) 'GHz_' stamp];
    mkdir(fdir);

    [~, ifreq] = min(abs([ratan.Freqs.freq] - freq));
    freq = ratan.Freqs(ifreq).freq*1e9;

    lng = length(ratan.Freqs(ifreq).I);
    srow0 = (ratan.XSCALE*((1:lng)-(lng+1)/2)+ratan.XCEN)/ratan.SOLAR_R;

    use = (srow0 > -wing & srow0 < wing);
    scan_src = ratan.Freqs(ifreq).I(use);
    level = mean(scan_src);
    scan = scan_src/level;
    srow = srow0(use);

    use = (srow0 > -wdraw & srow0 < wdraw);
    scandraw = ratan.Freqs(ifreq).I(use);
    scandraw = scandraw/level;
    srowdraw = srow0(use);

    [qs, arcsecs] = reuQuietSun(freq, ratan.SOLAR_R, ratan.XSCALE, gDiag_mode.std, gDisk_mode.bright);
    QS0 = interp1(arcsecs/ratan.SOLAR_R, qs, srow);
    QS0(QS0 < 1e-7) = 1e-7;
    [~, im0] = min(scan./QS0);
    QS0 = QS0/QS0(im0)*scan(im0); % QS0 - QS by lowest scan point;

    [hFig, hAxes] = ssuCreateMultiAxesFig(2, 3, '', true, false);
    hAxes(2, 2).Title.String = 'Resudual Var';
    hAxes(2, 3).Title.String = 'Resudual';
    set(hAxes(1, 1:2), 'XLim', [-1.3 1.3], 'YLim', [-0.1 max(scandraw)+0.1])
    hAxes(1, 2).Title.String = djsStr2TeX(fdir);
    set(hAxes, 'FontSize', 24)
    %set(hAxes(2, 2), 'YLim', [0.99 1.01]);

    plot(hAxes(1, 1), srowdraw, scandraw, 'LineWidth', 2, 'Color', 'k')
    plot(hAxes(1, 2), srowdraw, scandraw, 'LineWidth', 2, 'Color', 'k')

    drawnow

    tic

    %nm = NMGaussQS.NMGaussQS(srow, scan, ratan.SOLAR_R, ratan.XSCALE, freq, [], hAxes(1, 1));
    nm = NMGaussQS.NMGaussQS(srow, QS0, ratan.SOLAR_R, ratan.XSCALE, freq, [], hAxes(1, 1));
    [solution, approx, niter] = nm.process(gQS_mode.pow4, gDiag_mode.std, gDisk_mode.bright, [], [], 100, true);

    TQ = [];
    resid = [];
    residp = [];
    residc = NaN;
    params = [];
    prevappr = approx;
    cnt = 0;
    hPA = [];
    hPQ = [];
    hPD = [];
    while(cnt <= cntlim)
        delete([hPA hPQ hPD])
        qs = nm.calcscan(solution, gQS_mode.qs_only);

        cnt = cnt + 1;
        disp([num2str(cnt) ' ' num2str(niter) ' ' srvSecToDisp(toc) ', maxQS = ' num2str(max(qs)*level)])

        residp = [residp residc];
%         if any(isnan(residp))
%             idx = find(~isnan(residp));
%             if ~isempty(idx)
%                 residp(isnan(residp)) = residp(idx(1));
%             end
%         end
        delete(hAxes(2, 2).Children);
        plot(hAxes(2, 2), log10(residp), 'LineWidth', 2, 'Color', 'k');

        hPA = plot(hAxes(1, 2), srow, approx, 'LineWidth', 2, 'Color', 'r');
        hPQ = plot(hAxes(1, 2), srow, qs, 'LineWidth', 2, 'Color', 'g');
        TQ = [TQ max(qs)];
        delete(hAxes(2, 1).Children);
        plot(hAxes(2, 1), TQ, 'LineWidth', 2, 'Color', 'k');
        hAxes(2, 1).Title.String = num2str(floor(max(qs)*level));
        %set(hAxes(2, 1), 'YLim', [0, 1.2])

        delta = scan - prevappr;
        r = sqrt(sum(delta.^2 ./ scan))/length(scan);
        resid = [resid r];
        delete(hAxes(2, 3).Children);
        plot(hAxes(2, 3), log10(resid), 'LineWidth', 2, 'Color', 'k');
        hPD = plot(hAxes(1, 2), srow, delta, 'LineWidth', 2, 'Color', 'b');
        npeak = size(params, 1);
        if npeak > 0
            delete(hAxes(1, 3).Children);
            v = 2*sqrt(log(2)./solution(2:3:3*npeak))*ratan.SOLAR_R;
            histogram(hAxes(1, 3), v, nhist, 'FaceColor', 'y');
            plot(hAxes(1, 3), v, zeros(1, npeak), 'LineStyle', 'None', 'Marker', 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
            plot(hAxes(1, 3), [hw hw], [0 1], 'Color', 'r', 'LineWidth', 2);
        end

        drawnow
        hgexport(hFig, fullfile(fdir, ['iter_' sprintf('%05d', cnt) '.png']), hgexport('factorystyle'), 'Format', 'png');

        delete(hAxes(1, 1).Children);
        plot(hAxes(1, 1), srow, scan, 'LineWidth', 2, 'Color', 'k')

    %     if (cnt ~= switchlim)
    %         [~, im] = max(scan-prevappr);
    %         params = vertcat(params, [srow(im) dm]);
    %         if cnt == 0
    %             solution = (solution(1) + solution(2));
    %         end
    %     else
    %         qqq = solution(end);
    %         solution = solution(1:end-1);
    %         nm = NMGaussQS.NMGaussQS(srow, nm.QS, ratan.SOLAR_R, ratan.XSCALE, freq, [], []);
    %         [solutionQS0, approxQ0] = nm.process(gQS_mode.pow4, gDiag_mode.std, gDisk_mode.bright);
    %         snorm = solutionQS0(1) + solutionQS0(2);
    %         solution = [solution solutionQS0.*[qqq qqq 1 1 1 1 1]];
    %     end
    %     
    %     if (cnt < switchlim)
    %         cmode = mainmode;
    %     else
    %         cmode = gQS_mode.pow4;
    %     end

        %[~, im] = max(scan./prevappr);
        %[~, im] = max((scan-prevappr)./prevappr);
        [~, im] = max(scan - prevappr);
        params = vertcat(params, [srow(im) dm]);
        cmode = gQS_mode.pow4;

        showq = 100;
        nm = NMGaussQS.NMGaussQS(srow, scan, ratan.SOLAR_R, ratan.XSCALE, freq, params, hAxes(1, 1), showq);
        [solution, approx, niter] = nm.process(cmode, gDiag_mode.std, gDisk_mode.bright, solution, prevappr);
        prevappr = approx;

        if cnt > chi2n
            if r < res2dd
                break
            end
            clg = log(resid(end-chi2n+1:end));
            av = mean(clg);
            st = std(clg);
            residc = abs(st/av);
            if residc <= chi2dd
                break
            end
        end
    end
    toc
    
    save(fullfile(fdir, 'result.mat'), 'scandraw', 'srowdraw', 'srow', 'approx', 'solution', 'qs', 'TQ', 'resid', 'infits')
    rat_tqsun = ratan.Freqs(ifreq).tqsun;
    to_save = [to_save struct('freq', freq, 'srow', srow, 'scan_src', scan_src, 'rat_tqsun', rat_tqsun, 'qs', qs ...
              , 'scandraw', scandraw, 'srowdraw', srowdraw, 'approx', approx, 'solution', solution, 'TQ', TQ, 'resid', resid, 'infits', infits)];

    save_to = fullfile(fdirall, ['freq_' num2str(freq)]);
    hgexport(hFig, fullfile([save_to '.png']), hgexport('factorystyle'), 'Format', 'png');
    savefig(hFig, fullfile([save_to '.fig']), 'compact');
    delete(hFig)
end

save(fullfile(fdirall, 'result_all.mat'), 'to_save')

end
