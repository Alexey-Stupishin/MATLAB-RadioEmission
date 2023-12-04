function [B, Bs, Bsm] = fpuMEmedian(B0, r)

Bs = fpuMEField2QStokes(B0);

tic
Bsm.V = asm_medianCircle(Bs.V, r);
toc
Bsm.Q = asm_medianCircle(Bs.Q, r);
toc
Bsm.U = asm_medianCircle(Bs.U, r);
toc

B = fpuQStokes2MEField(Bsm);

end
