function pt = pascalTriangle(n)

pt = zeros(n+1);

pt(1, 1) = 1;
for k = 2:n+1
    padd = [0 pt(k-1, 1:k-1) 0];
    pt(k, 1:k) = padd(1:k) + padd(2:k+1);
end

end
