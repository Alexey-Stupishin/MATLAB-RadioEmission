function comblist(root, common)

if ~exist('common', 'var')
    common = [];
end

for k = 1:length(root)
    if ~isempty(root(k).tree)
        if isempty(root(k).tree(1).tree)
            l_proceed(root(k).tree, common);
            continue
        else
            comblist(root(k).tree, common);
        end
    end
end

end

%--------------------------------------------------------------------------
function l_proceed(lists, common)

for k = 1:length(lists)
end

end
