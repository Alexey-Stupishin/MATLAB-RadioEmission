function param = reoGetParam(npos, nreg, nH, nfreq)

param.barometric = false;

param.wFreq = 1; 
param.wTemp = 1; 
param.wCross = 1;

param.Hmin = 1;
param.Hb = 1;
param.Tb = 6e3;

param.wR = ones(npos, nfreq); 
param.wL = ones(npos, nfreq);
param.wT = ones(nreg, nH);

param.harms = 2:4;
param.mode = 3;
param.c = 0;
param.b = 0;
param.pTauL = [1 100];
param.dunit = 1;
param.Tmin = 6e3*ones(1, nreg);

param.resabslim = 1e-2;
param.reslim = 3e-2;
param.rescntstab = 20;
param.rescntmax = 50;
param.expMax = 3;
param.expMin = 1/param.expMax;

param.fluxLim = 0.05;
param.thinLim = 0.5;
param.thinPow = 0.5;
param.useLim = 0.0;
param.solve_mode = '-NM';

param.Hshow = 0;

param.scanlims = [];

end

% GM
% param.wFreq = 1; 
% param.wTemp = 10; 
% param.wTemp_D = 10;
% param.wR = 1; 
% param.wL = 1; 
% param.relax = 1; 
% 
% param.harms = 2:4;
% param.mode = 3;
% param.c = 0;
% param.b = 0;
% param.pTauL = [1 25];
% param.Tmin = 6000;
% 
% param.reslim = 5e-4;
% param.rescntstab = 10;
% param.rescntmax = 30;
% param.expMax = 1.5;
% param.expMin = 1./param.expMax;

% GM changed
% param.wTemp = 3;
% param.wTemp_D = 0;
% param.rescntmax = 70;
