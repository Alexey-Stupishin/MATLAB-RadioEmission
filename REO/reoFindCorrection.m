function x = reoFindCorrection(M, F, T, nEqF, nEqT, w)

n = size(M, 2);
initsimp = ones(n+1, n);
for k = 1:n
    initsimp(k, k) = 1.1;
end

x = NelderMead(@l_calc, @l_crit, @l_bound, initsimp, 1, 2, 0.5, 0.5);

    function x = l_bound(x)
        lims = 1e10;
        for i = 1:n
            if x(i) < 1/lims
                x(i) = 1/lims;
            elseif x(i) > lims
                x(i) = lims;
            end
            
            if T(i)*x(i) < 6000
                x(i) = 6000/T(i);
            end
            if T(i)*x(i) > 1e8
                x(i) = 1e8/T(i);
            end
        end
    end

    function f = l_calc(x)
        rangeF = 1:nEqF;
        rangeT = nEqF + (1:nEqT);
        f = sum((M(rangeF, :)*x' - F(rangeF)').^2) + w*sum((M(rangeT, :)*x' - F(rangeT)').^2);
    end

    function conv = l_crit(x, ~)
        conv = all(std(x, 0, 1) < 1e-8);
    end

end
