function [resamp, xres] = asmGetLanczosResample(f, f_step, lanczos, a, lanz_step)

[nsteps, xf] = asmGetLanczosSize(f, f_step);

xres = (0:nsteps-1)*f_step;

resamp = zeros(1, nsteps);
for k = 1:nsteps
    x = (k-1)*f_step;
    for aa = -a:a
        idxf = floor(x) + aa + 1;
        if idxf < 1 || idxf > length(f), continue, end
        idxl = floor(abs(x-xf(idxf))/lanz_step)+1;
        if idxl < 1 || idxl > length(lanczos), continue, end
        resamp(k) = resamp(k) + f(idxf)*lanczos(idxl);
    end
end

end
