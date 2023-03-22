function ss = calcCnk(n, s, a, b)
% calculates sum(C(n)(k) * s^k /(a*k + b))

fact = ones(1, n+1);
for kn = 1:n
    fact(kn+1) = fact(kn)*kn;
end

ss = 0;
for kn = 1:n+1
    k = kn - 1;
    ss = ss + s^k / (fact(kn) * fact(n+2-kn) * (a*k+b));
end

ss = ss*fact(end);

end
