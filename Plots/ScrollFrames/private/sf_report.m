function sf_report(handles)

d1 = handles.info;
d2 = handles.D2.info;

%      max_depth: 3
%      last_succ: 69
%     last_total: 101
%        dthetaB: 25.354224824015
%       residual: 0.239657463938023
%           time: 51.3380269
%             dL: 0.155329180376567
%              L: [78x1 double]
%       div_part: 0.220927660129859
%          sigma: [78x1 double]
%         sigmaJ: [78x1 double]
%         sigmaB: [78x1 double]
%         sigmaT: 47.7258579437017
%        sigmaJT: 27.9609836352235
%        sigmaBT: 43.7876677800393

x = 1:size(d1.L, 1); x = x';

[hFig, hAxes, hTitle] = ssuCreateMultiAxesFig(2, 3);
h1 = plot(hAxes(1, 1), x, d1.L);
h2 = plot(hAxes(1, 1), x, d2.L);
set(hAxes(1, 1), 'YScale', 'log');
legend([h1 h2], {num2str(d1.dL), num2str(d2.dL)});

% h1 = plot(hAxes(1, 2), x, d1.sigma);
% h2 = plot(hAxes(1, 2), x, d2.sigma);
% legend([h1 h2], {num2str(d1.sigmaT), num2str(d2.sigmaT)});

h1 = plot(hAxes(1, 2), x, d1.sigmaJ);
h2 = plot(hAxes(1, 2), x, d2.sigmaJ);
legend([h1 h2], {num2str(d1.sigmaJT), num2str(d2.sigmaJT)});

h1 = plot(hAxes(1, 3), x, d1.sigmaB);
h2 = plot(hAxes(1, 3), x, d2.sigmaB);
legend([h1 h2], {num2str(d1.sigmaBT), num2str(d2.sigmaBT)});

h1 = plot(hAxes(2, 1), x, d1.dtheta);
h2 = plot(hAxes(2, 1), x, d2.dtheta);
legend([h1 h2], {num2str(d1.dthetaT), num2str(d2.dthetaT)});

h1 = plot(hAxes(2, 2), x, d1.dthetaB);
h2 = plot(hAxes(2, 2), x, d2.dthetaB);
legend([h1 h2], {num2str(d1.dthetaBT), num2str(d2.dthetaBT)});

h1 = plot(hAxes(2, 3), x, d1.residual);
h2 = plot(hAxes(2, 3), x, d2.residual);
legend([h1 h2], {num2str(d1.residualT), num2str(d2.residualT)});

end
