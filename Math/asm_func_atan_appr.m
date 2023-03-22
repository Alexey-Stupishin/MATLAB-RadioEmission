function t = asm_func_atan_appr(hh, y0, A, k, xc)

t = y0 + A*atan(k*(hh-xc));

end
