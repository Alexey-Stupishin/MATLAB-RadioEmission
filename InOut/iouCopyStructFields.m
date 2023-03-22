function s = iouCopyStrucFields(s, sbase)

fn = fieldnames(s);
for k = 1:length(fn)
    if (isfield(sbase, fn{k}))
        s.(fn{k}) = sbase.(fn{k});
    end
end

end
