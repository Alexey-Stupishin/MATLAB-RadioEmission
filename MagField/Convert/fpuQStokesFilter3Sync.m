function [Bsm, Bm] = fpuQStokesFilter3Sync(Bs0, radius, med_factor, rel_factor_high, rel_factor_low)
% QS = fpuQStokesFilter3(QS0, 3, 1, 0.15, 0.15);

Bsm.U = zeros(size(Bs0.U));
Bsm.V = zeros(size(Bs0.U));
Bsm.Q = zeros(size(Bs0.U));

for k = 1:size(Bsm.V, 3)
    Bs.U = Bs0.U(:,:,k);
    Bs.V = Bs0.V(:,:,k);
    Bs.Q = Bs0.Q(:,:,k);
%    MEin = fpuQStokes2MEField(Bs);
    
    [cU, mU] = fpuQStokesGetFilter(Bs, Bs.U, radius, med_factor, rel_factor_high, rel_factor_low);
    [cV, mV] = fpuQStokesGetFilter(Bs, Bs.V, radius, med_factor, rel_factor_high, rel_factor_low);
    [cQ, mQ] = fpuQStokesGetFilter(Bs, Bs.Q, radius, med_factor, rel_factor_high, rel_factor_low);
%     m.U = mU;
%     m.V = mV;
%     m.Q = mQ;
%     MEm = fpuQStokes2MEField(m);
    
%     s.U = Bs.U;
%     s.U(cU) = mU(cU);
%     s.V = Bs.V;
%     s.V(cV) = mV(cV);
%     s.Q = Bs.Q;
%     s.Q(cQ) = mQ(cQ);
%     ME = fpuQStokes2MEField(s);
    
    cA = cQ | cU | cV;
    a.U = Bs.U;
    a.U(cA) = mU(cA);
    Bsm.U(:,:,k) = a.U;
    a.V = Bs.V;
    a.V(cA) = mV(cA);
    Bsm.V(:,:,k) = a.V;
    a.Q = Bs.Q;
    a.Q(cA) = mQ(cA);
    Bsm.Q(:,:,k) = a.Q;
%     MEa = fpuQStokes2MEField(a);
    
%     Bsm.U(:,:,k) = fpuQStokesFilter(Bs, Bs.U, radius, med_factor, rel_factor_high, rel_factor_low);
%     Bsm.V(:,:,k) = fpuQStokesFilter(Bs, Bs.V, radius, med_factor, rel_factor_high, rel_factor_low);
%     Bsm.Q(:,:,k) = fpuQStokesFilter(Bs, Bs.Q, radius, med_factor, rel_factor_high, rel_factor_low);
    disp(k)
end

Bm = fpuQStokes2MEField(Bsm);

end
