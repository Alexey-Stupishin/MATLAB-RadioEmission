function value = iouFitsInfoKey(info, key)

value = [];

keywords = info.PrimaryData.Keywords(:,1);
idx = find(strcmp(key, keywords(:, 1)), 1);
if ~isempty(idx)
    value = info.PrimaryData.Keywords{idx, 2};
end

end
