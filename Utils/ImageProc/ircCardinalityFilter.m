function [clust, rd] = ircCardinalityFilter(clust, card, rd)

if ~exist('rd', 'var')
    rd = [];
end

av = 0;
if ~isempty(rd)
    av = mean(reshape(rd, [1 numel(rd)]));
end
for k = 1:xmax2(clust)
    if numel(clust(clust == k)) < card
        if ~isempty(rd)
            rd(clust == k) = av;
        end
        clust(clust == k) = 0;
    end
end

end
