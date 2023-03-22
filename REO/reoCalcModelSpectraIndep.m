function [Robs, Lobs, rescalc, M, base] = reoCalcModelSpectraIndep(libname, QT, freefree, mfoData, freqs, atm, step)

hLib = reoInitLibrary(QT, freefree, libname);
if hLib == 0
    return
end

gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree', 1 );
gstSetPreferenceInt(hLib, 'cycloCalc.ConsiderFreeFree.Only', 0 );
%gstSetPreferenceInt(hLib, 'cycloMap.nThreadsInitial', 1);

[M, base, Bmk] = reoSetField(hLib, mfoData, [step step]);
atm.mask = true(M(1), M(2));
BBm = fpuFieldVal(Bmk);
[~, ~, pos] = xmax2(BBm);
[Robs, Lobs, rescalc] = reoCalcModelSpectra(hLib, freqs, M, step, base, 2:4, pos, atm);

utilsFreeLibrary(hLib);

end
