function par = ssuProceedLinesParams(model)

par.lw = 0.5;
par.lcol = [0 0.3 0];
par.alphav = 0.2;

if strcmp(model, 'POT')
    par.Bmax = 1;
    par.rel_por = 2;
    par.alphaa = 0.15;
else
    par.Bmax = 3;
    par.rel_por = 3;
    par.alphaa = 0.15;
end
par.lwa = 0.5;
par.lcola = [0 1 1];

par.height_from = 2;

par.B_from = 15;
par.hmax = 50000;
par.hrange = [];
par.closed = true;
par.opened = true;
par.lngmax = 15;

par.WOLines = false;

par.limharm = 1;
par.freq = 0;

par.visstep = 1;
par.aiaN = 1; % NB!

par.useinterp = true;
par.draw = true;

end
