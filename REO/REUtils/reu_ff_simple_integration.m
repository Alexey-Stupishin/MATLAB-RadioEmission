function [kFF, T, tau] = reu_ff_simple_integration(hh, temp, dens, f)

kFF = zeros(1, length(hh));
T = zeros(1, length(hh));
tau = zeros(1, length(hh));
for h = (length(hh)-1):-1:1
    kFF(h) = reu_kFF(temp(h), dens(h), f);
    this_tau = kFF(h)*(hh(h+1)-hh(h));
    T(h) = T(h+1) + temp(h)*(1-exp(-this_tau))*exp(-tau(h+1));
    tau(h) = tau(h+1) + this_tau;
end
    
end
