function skres = d3same_sk(sk)

groups = {};
used = zeros(1, length(sk));
for k = 1:length(sk)
    g = withsign(sk{k}{1}, k);
    for p = (k+1):length(sk)
        if used(p) == 0 && thesame(sk{k}, sk{p})
            g = [g withsign(sk{p}{1}, p)];
            used(k) = length(groups)+1;
            used(p) = length(groups)+1;
        end
    end
    if length(g) > 1
        groups = [groups {g}];
    end
end

mults = zeros(1, length(groups));
rem = 0;
for k = 1:length(groups)
    for p = 1:length(groups{k})
        mults(k) = mults(k) + sign(groups{k}(p));
    end
    rem = rem + length(groups{k}) + pick(mults(k) == 0, 0, -1);
end

group_n = used;
skres = {};
for k = 1:length(sk)
    if used(k) < 0
        continue
    elseif used(k) == 0
        v = 1;
    else
        same = used(k);
        v = mults(same);
        if v == 0
            continue
        end
        for p = 1:length(groups{same})
            used(abs(groups{same}(p))) = -1;
        end
    end
    skres = {skres{:} {v, sk{k}{2:end}}};
end

end

%--------------------------------------------------------------------------
function v = withsign(sg, n)

v = n;
if strcmp(sg, '-')
    v = -n;
end

end

%--------------------------------------------------------------------------
function same = thesame(s1, s2)

same = false;
if length(s1) ~= length(s2)
    return
end

for k = 2:length(s1)
    if ~strcmp(s1{k}, s2{k})
        return
    end
end

same = true;

end
