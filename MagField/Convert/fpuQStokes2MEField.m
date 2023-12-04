function B = fpuQStokes2MEField(Bs)
% Bs - field in B.QS (quasi-Stokes) form (B.V, B.Q, B.U) (see Rudenko, Myshyakov, Anfinogentov)
% B - observed field in B.ME (Milne-Eddington, MERLIN) form (B.absB, B.incl, B. azim)

transv = Bs.Q.^2 + Bs.U.^2;
B.absB = sqrt(Bs.V.^2 + transv);
B.incl = acosd(Bs.V ./ B.absB);
B.incl(isnan(B.incl)) = 0;
B.azim = atan2d(Bs.U, Bs.Q)/2;
B.azim(B.azim < 0) = B.azim(B.azim < 0) + 180;

end
