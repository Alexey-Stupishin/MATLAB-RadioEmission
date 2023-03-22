function D = asuGetBarometricD(H, T, NT)

H0 = H(1);
NTx = NT*exp(-(H-H0)/4.5e3./T);
D = NTx./T;

end
