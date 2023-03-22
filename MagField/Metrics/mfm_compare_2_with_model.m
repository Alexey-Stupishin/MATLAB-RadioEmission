function [devpmx, devpmwx, devpmy, devpmwy, devpmz, devpmwz, devpma, devpmwa ...
        , devrpx, devrpwx, devrpy, devrpwy, devrpz, devrpwz, devrpa, devrpwa ...
         ] = mfm_compare_2_with_model(rest, mod, subst, phys)

[devpmx, devpmwx, devpmy, devpmwy, devpmz, devpmwz, devpma, devpmwa] = mfaBaseMetrics(subst, mod, phys(1), phys(2), phys(3));
[devrpx, devrpwx, devrpy, devrpwy, devrpz, devrpwz, devrpa, devrpwa] = mfaBaseMetrics(subst, rest, phys(1), phys(2), phys(3));

end
