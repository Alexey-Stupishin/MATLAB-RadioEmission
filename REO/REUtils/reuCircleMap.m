function rmap = reuCircleMap(Nv, Nh, R, dRout, dRin, dT, PC)
% R in terms of step

if ~exist('dRout', 'var')
    dRout = 1;
end
if ~exist('dRin', 'var')
    dRin = 1;
end
if ~exist('dT', 'var')
    dT = 1;
end
if ~exist('PC', 'var')
    PC = 1;
end

if dT ~= 1
    dRout = R*dRout;
    dRin = R*dRin;
    PC = R*PC;
    alpha1 = log(2/dT)/(dRout-PC)^2;
    alpha2 = log(2/dT)/(PC-dRin)^2;
end

rmap = zeros(Nv, Nh);
ch = (Nh-1)/2;
cv = (Nv-1)/2;
for kh = 1:Nh
    for kv = 1:Nv
        rv = (kh-ch)^2 + (kv-cv)^2;
        if dT ~= 1
            v = l_calc(sqrt(rv));
        else    
            if rv <= R^2
                v = 1;
            else
                v = 0;
            end
        end
        rmap(kv, kh) = v;
    end
end

    function v = l_calc(rv)
        if rv >= PC
            v = dT*exp(-alpha1*(rv-PC)^2);
        else
            v = 1 + (dT-1)*exp(-alpha2*(PC-rv)^2);
        end
    end

end
