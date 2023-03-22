function [res, rnums] = d3sort_sk(sk)

nums = zeros(length(sk), 4, 7);
charns = int64(zeros(1, length(sk)));
for k = 1:length(sk)
    nums(k, 1, 1) = pick(strcmp(sk{k}{1}, '+'), 1, -1);
    for p = 2:length(sk{k})
        [nums(k, :, p), cn] = vectAlgebra.d3str2num(sk{k}{p});
        charns(k) = charns(k)*190 + cn;
    end
end

[~, is] = sort(charns);

res = sk(is);
rnums = nums(is, :, :);

end
