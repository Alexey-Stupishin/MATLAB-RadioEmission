function [nsteps, xf] = asmGetLanczosSize(f, f_step)

xf = (1:length(f)) - 1;
nsteps = (xf(end)-xf(1))/f_step + 1;
if floor(nsteps) ~= nsteps
    nsteps = ceil(nsteps);
end

end
