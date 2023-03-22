function reoPlotScans(s1, s2)

xsurf(s1.B);
xsurf(s2.B);
xrange1 = (0:s1.M(2)-1)*s1.step + s1.base(2);
xrange2 = (0:s2.M(2)-1)*s2.step + s2.base(2);

tab1 = zeros(s1.M(2), length(s1.scans)+1);
tab1(:, 1) = xrange1';
tab2 = zeros(s2.M(2), length(s2.scans)+1);
tab2(:, 1) = xrange2';
tab3 = zeros(s1.M(2), length(s1.scans)+1);
tab3(:, 1) = xrange1';
tab4 = zeros(s2.M(2), length(s2.scans)+1);
tab4(:, 1) = xrange2';

for k = 1:length(s1.scans)
    id = [s1.id '_' num2str(s1.scans(k).freq*1e-9) 'GHz'];

    hFig = figure('Name', id);
    p1 = plot(xrange1, s1.scans(k).Right); hold on
    tab1(:, k+1) = s1.scans(k).Right';
    p2 = plot(xrange2, s2.scans(k).Right); hold on
    tab2(:, k+1) = s2.scans(k).Right';
    p3 = plot(xrange1, s1.scans(k).Left); hold on
    tab3(:, k+1) = s1.scans(k).Left';
    p4 = plot(xrange2, s2.scans(k).Left); hold on
    tab4(:, k+1) = s2.scans(k).Left';
    xlabel('arcsec');
    legend([p1 p2 p3 p4], l_legend(s1, 'Right'), l_legend(s2, 'Right'), l_legend(s1, 'Left'), l_legend(s2, 'Left'), 'Location','northoutside');

    hgexport(hFig, fullfile('c:\temp', [id '.png']), hgexport('factorystyle'), 'Format', 'png');
end

freqs = [0 [s1.scans.freq]*1e-9];
tab1 = vertcat(freqs, tab1);
tab2 = vertcat(freqs, tab2);
tab3 = vertcat(freqs, tab3);
tab4 = vertcat(freqs, tab4);
dlmwrite(['c:\temp\' s1.id '_az' num2str(s1.azimuth) '_Right.dat'], tab1, 'delimiter', '\t');
dlmwrite(['c:\temp\' s2.id '_az' num2str(s2.azimuth) '_Right.dat'], tab2, 'delimiter', '\t');
dlmwrite(['c:\temp\' s1.id '_az' num2str(s1.azimuth) '_Left.dat'], tab3, 'delimiter', '\t');
dlmwrite(['c:\temp\' s2.id '_az' num2str(s2.azimuth) '_Left.dat'], tab4, 'delimiter', '\t');
% fid1 = fopen(['c:\temp\' s1.id '_Right.dat']);
% fid2 = fopen(['c:\temp\' s2.id '_Right.dat']);
% fid3 = fopen(['c:\temp\' s1.id '_Left.dat']);
% fid4 = fopen(['c:\temp\' s2.id '_Left.dat']);
% fclose(fid1);
% fclose(fid2);
% fclose(fid3);
% fclose(fid4);

end

%--------------------------------------------------------------------------
function v = l_legend(s, pol)

v = ['az = ' num2str(s.azimuth) ', ' pol ', ' s.time ' pos.angle = ' num2str(s.posangle)];

end
