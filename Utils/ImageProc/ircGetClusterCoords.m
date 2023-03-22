function [x, y] = ircGetClusterCoords(clust, n)

x = [];
y = [];

for kx = 1:size(clust, 1)
    for ky = 1:size(clust, 2)
        if clust(kx, ky) == n
            x = [x kx];
            y = [y ky];
        end
    end
end

end
