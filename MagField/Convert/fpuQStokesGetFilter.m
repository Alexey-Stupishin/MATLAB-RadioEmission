function [changed, vm, n] = fpuQStokesGetFilter(Bs, v0, radius, med_factor, rel_factor_high, rel_factor_low)

vm = asm_medianCircle(v0, radius);

crit = (Bs.V == 0 & Bs.Q == 0 & Bs.U == 0) | isnan(Bs.V) | isnan(Bs.U) | isnan(Bs.Q);
vf = reshape(v0, [1, numel(v0)]);
vf(crit) = [];
threshold = median(median(abs(vf), 1), 2) * med_factor; % total median * factor
critm = ~crit & abs(v0) < threshold; % below threshold 
critmv = ~crit & ~critm & abs(v0-vm) < rel_factor_high*abs(vm); % ok if above threshold and difference small relate to median
crith = ~crit & abs(v0) >= threshold; % above threshold
critmh = ~crit & ~crith & abs(v0-vm) < rel_factor_low*threshold; % ok if below threshold and difference small relate to threshold
changed = ~crit & ~critmv & ~critmh;
n = xsum2(changed);

end
