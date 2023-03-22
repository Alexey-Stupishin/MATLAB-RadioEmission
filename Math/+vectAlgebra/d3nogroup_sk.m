function root = d3nogroup_sk(sk)

root = [];

curr = sk;
for k = 1:length(curr)
    last = [];
    c = curr{k};
    for p = length(c):-1:2
        s.name = c{p};
        [s.num, s.charn] = vectAlgebra.d3str2num(c{p});
        s.tree = last;
        s.mult = pick(p < length(c), 1, c{1});
        last = s;
    end
    root = [root last];
end
