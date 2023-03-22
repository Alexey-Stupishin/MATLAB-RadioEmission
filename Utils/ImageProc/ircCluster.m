function [clust, clustn] = ircCluster(mask, diag)

clust = zeros(size(mask));
% passed = false(size(mask));

clustn = 0;
for kx = 1:size(mask, 1)
    for ky = 1:size(mask, 2)
        if ~mask(kx, ky) || clust(kx, ky) > 0 % passed(kx, ky)
            continue
        end
        
        clustn = clustn + 1;
        l_proc(kx, ky);
        
    end
    if ~mask(kx, ky) || clust(kx, ky) > 0 % passed(kx, ky)
        continue
    end
end

    function l_proc(x, y)
        % passed(x, y) = true;
        if ~mask(x, y) || clust(x, y) > 0
            return
        end

        clust(x, y) = clustn;
        for kxx = x-1:x+1
            for kyy = y-1:y+1
                if (kxx < 1 || kxx > size(mask,1) || kyy < 1 || kyy > size(mask,2))
                    continue
                end
                if ~diag && ~(x == kxx || y == kyy)
                    continue
                end

                l_proc(kxx, kyy);
            end
        end
    end

end