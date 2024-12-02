function [coef, delta_v, delta_h] = asmScaleRects(master, slave)

vm2s = master(1)/slave(1);
hm2s = master(2)/slave(2);

coef = min(vm2s, hm2s);

res_slave = slave*coef;
delta_v = master(1) - res_slave(1);
delta_h = master(2) - res_slave(2);

end
