function f2009 = getFontenla2009Ext

f2009 = getFontenla2009;

stepMm = 0.1;
maxHMm = 30;

%logTcor = log10([1.2 1.4 1.6 2.0 2.3 2.0 1.6]*1e6);
logTcor = log10([1.2 1.4 1.6 2.1 3 2.1 1.6]*1e6);

for m = 1:7
    % xplot(f2009.profs(m).H, log10(f2009.profs(m).TEMP.*f2009.profs(m).NNE))
    lng = length(f2009.profs(m).H);
    [HH, logTT] = asuAddCoronaT(f2009.profs(m).H, log10(f2009.profs(m).TEMP), 1, 0.97, 10, logTcor(m), stepMm, maxHMm);
    f2009.profs(m).H = HH;
    f2009.profs(m).TEMP = 10.^(logTT);
    
    Hu = f2009.profs(m).H(lng:end);
    Tu = f2009.profs(m).TEMP(lng:end);
    Du = f2009.profs(m).NNE(lng:end);
    D = asuGetBarometricD(Hu, Tu, Du(1)*Tu(1));
    f2009.profs(m).NNE = [f2009.profs(m).NNE; D(2:end)];
    % xplot(f2009.profs(m).H, log10(f2009.profs(m).TEMP.*f2009.profs(m).NNE))

    f2009.profs(m).DH = [f2009.profs(m).DH; stepMm*1e8*ones(length(f2009.profs(m).H)-lng, 1)];
end

end
