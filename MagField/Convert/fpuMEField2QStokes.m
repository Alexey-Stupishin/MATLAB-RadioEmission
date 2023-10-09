function Bs = fpuMEField2QStokes(B)
% B - observed field in B.ME (Milne-Eddington, MERLIN) form (B.absB, B.incl, B. azim)
% Bs - field in B.QS (quasi-Stokes) form (B.V, B.Q, B.U) (see Rudenko, Myshyakov, Anfinogentov)

Bs.V =   B.absB .* cosd(B.incl);
transv = B.absB .* sind(B.incl);
Bs.Q =   transv .* cosd(2*B.azim);
Bs.U =   transv .* sind(2*B.azim);

end
