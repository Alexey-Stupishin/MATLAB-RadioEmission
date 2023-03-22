function value = iouFitsGetKey(keywords, key)

value = [];

idx = find(strcmp(key, keywords(:, 1)), 1);
if ~isempty(idx)
    value = keywords{idx, 2};
end

end
