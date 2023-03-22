function res = medianF1D(scan, hwin)

res = scan;
for k = hwin+1:length(scan)-hwin
    res(k) = median(scan(k-hwin:k+hwin));
end

end
