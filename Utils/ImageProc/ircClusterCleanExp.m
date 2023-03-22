function clust = ircClusterCleanExp(clust, mask, ~)

clust(~mask) = 0;

end
