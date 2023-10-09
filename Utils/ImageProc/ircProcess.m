function jets = ircProcess(rd, par)

jets = [];

[mask, av1] = ircGetMask(rd, par.sigma1);
clust = ircCluster(mask, true);

[clust, rd] = ircCardinalityFilter(clust, par.card1, rd);

[mask, av2] = ircGetMask(rd, par.sigma2);
maskexp = ircExpandMask(mask, par.border);
clust = ircCluster(maskexp, false);
clust = ircClusterCleanExp(clust, mask, maskexp);

clust = ircCardinalityFilter(clust, par.card2);

for k = 1:xmax2(clust)
    [x, y] = ircGetClusterCoords(clust, k);
    found = false;
    if length(x) >= par.card2
        [Vx, Vy] = asmPrincComp2D(x, y);
        asp = Vx/Vy;
        asp = pick(asp > 1, asp, 1/asp);
        if asp > par.ellipse
            found = true;
        end
    end
    
    if found
        j.image = false(size(clust));
        j.image(clust == k) = true;
        j.aspect = asp;
        j.cardinality = length(x);
        j.box.x = [min(x) max(x)];
        j.box.y = [min(y) max(y)];
        j.center.x = mean(x);
        j.center.y = mean(y);
        
        jets = [jets j]; %#ok
    end
end

end
