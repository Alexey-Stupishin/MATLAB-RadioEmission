function outLowLouPN(filename, n, nsteps)

lambdas = [0 4.27408e-01 2.54324e+00 8.76005e+00 2.28683e+01 5.02353e+01 9.79814e+01 1.75140e+02];

fout = fopen(filename, 'w');

fprintf(fout, '%d %d %d\r\n', n, length(lambdas), nsteps);
for k = 1:length(lambdas)
    fprintf(fout, '%e ', lambdas(k));
end
fprintf(fout, '\r\n');

Ys = zeros(nsteps, 2*length(lambdas));

for k = 1:length(lambdas)
    [T, Y] = getLowLouP(n, lambdas(k), nsteps);
    if length(T) < nsteps
        T(nsteps) = 1;
        Y(nsteps, 1) = 0;
        Y(nsteps, 2) = 10*(-1)^k;
    end
    Ys(:, 2*k-1) = Y(:, 1);
    Ys(:, 2*k  ) = Y(:, 2);
end

for ks = 1:nsteps
    fprintf(fout, '%d %e ', ks, T(ks));
    for k = 1:(2*length(lambdas))
        fprintf(fout, '%e ', Ys(ks, k));
    end
    fprintf(fout, '\r\n');
end

fclose(fout);

end
