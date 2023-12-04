function [v, vm, changed, n] = fpuQStokesFilter(Bs, v0, radius, med_factor, rel_factor_high, rel_factor_low)

vm = asm_medianCircle(v0, radius);

crit = Bs.V == 0 & Bs.Q == 0 & Bs.U == 0;
vf = reshape(v0, [1, numel(v0)]);
vf(crit) = [];
meus = median(median(abs(vf), 1), 2) * med_factor;
critm = ~crit & abs(v0) < meus;
critmv = ~crit & ~critm & abs(v0-vm) < rel_factor_high*abs(vm);
crith = ~crit & abs(v0) >= meus;
critmh = ~crit & ~crith & abs(v0-vm) < rel_factor_low*meus;
changed = ~crit & ~critmv & ~critmh;
v = v0;
v(changed) = vm(changed);
n = xsum2(changed);

end
