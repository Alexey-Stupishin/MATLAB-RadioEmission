function B = fpuMEmedian(B0, r)

Bs = fpuMEField2QStokes(B0);

Bsm.V = asm_medianCircle(Bs.V, r);
Bsm.Q = asm_medianCircle(Bs.Q, r);
Bsm.U = asm_medianCircle(Bs.U, r);

B = fpuQStokes2MEField(Bsm);

end
