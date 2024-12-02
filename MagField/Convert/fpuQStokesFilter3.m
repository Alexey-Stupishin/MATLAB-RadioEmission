function [Bsm, Bm] = fpuQStokesFilter3(Bs0, radius, med_factor, rel_factor_high, rel_factor_low)

Bsm.U = zeros(size(Bs0.U));
Bsm.V = zeros(size(Bs0.U));
Bsm.Q = zeros(size(Bs0.U));

for k = 1:size(Bsm.V, 3)
    Bs.U = Bs0.U(:,:,k);
    Bs.V = Bs0.V(:,:,k);
    Bs.Q = Bs0.Q(:,:,k);
    Bsm.U(:,:,k) = fpuQStokesFilter(Bs, Bs.U, radius, med_factor, rel_factor_high, rel_factor_low);
    Bsm.V(:,:,k) = fpuQStokesFilter(Bs, Bs.V, radius, med_factor, rel_factor_high, rel_factor_low);
    Bsm.Q(:,:,k) = fpuQStokesFilter(Bs, Bs.Q, radius, med_factor, rel_factor_high, rel_factor_low);
    disp(k)
end

Bm = fpuQStokes2MEField(Bsm);

end
