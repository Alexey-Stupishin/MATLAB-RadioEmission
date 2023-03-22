function [B, h] = mfoMaxFieldProfile(mfoData)

BB = fpuFieldVal(mfoData.B);

h = (0:size(BB,3)-1)*mfoData.step(3)/mfoData.R*6.96e5;
h(h > 20000) = [];
B = zeros(1, length(h));
for k = 1:length(h)
    B(k) = xmax2(BB(50:80,110:150,k));
end

end
