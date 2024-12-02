function [v, vm, changed, n] = fpuQStokesFilter(Bs, v0, radius, med_factor, rel_factor_high, rel_factor_low)

[changed, vm, n] = fpuQStokesGetFilter(Bs, v0, radius, med_factor, rel_factor_high, rel_factor_low);

v = v0;
v(changed) = vm(changed);

end
