function [res, rnums] = d3simp_sk(sk, nums)

% nums = zeros(length(sk), 4, 7);
prev = nums(1, :, 2:end);
prevk = 1;
excl = false(length(sk), 1);
for k = 2:length(sk)
    if all(all(nums(k, :, 2:end) - prev == 0))
        excl(k) = true;
        nums(prevk, 1, 1) = nums(prevk, 1, 1) + nums(k, 1, 1);
    else
        prev = nums(k, :, 2:end);
        prevk = k;
    end
end

excl = (excl | squeeze(nums(:, 1, 1)) == 0);

res = sk(~excl);
rnums = nums(~excl, :, :);

for k = 1:length(res)
%    res{k}{1} = sprintf('%+1d', rnums(k, 1, 1));
    res{k}{1} = rnums(k, 1, 1);
end

end
