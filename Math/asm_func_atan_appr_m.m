function t = asm_func_atan_appr_m(hh, logTg, logTcor, g, xg)

A = (logTcor - logTg)*2/pi;
t = asm_func_atan_appr(hh, logTg, A, g, xg);
 
end
