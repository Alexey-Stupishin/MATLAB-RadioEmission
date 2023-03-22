function LnC = reuColoumbLog(T, f)

LT = log(T);
t = pick(T < 8.92e5, 17.72 + 1.5*LT, 24.57 + LT);
LnC = t - log(f);

end
