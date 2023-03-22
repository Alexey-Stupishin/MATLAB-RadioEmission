function kFF = reu_kFF(T, N, f)

LnC = reuColoumbLog(T, f);
c = 9.78e-3*1.14*LnC;

kFF = c*N^2/(T^1.5 * f^2);

end
