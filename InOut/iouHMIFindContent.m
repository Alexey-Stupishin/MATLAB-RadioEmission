function [content, source] = iouHMIFindContent(info, keys)

source = [];
content = '';

for k = 1:length(info.Contents)
    if (strcmp(info.Contents{k}, 'Primary'))
        cf = 'PrimaryData';
        content = 'primary';
    elseif (strcmp(info.Contents{k}, 'Image'))
        cf = 'Image';
        content = 'image';
    else
        continue
    end
    
    kwds = info.(cf).Keywords;
    idxdateobs = find(strcmp(kwds, 'DATE-OBS'));
    if ~isempty(idxdateobs)
        kwds{idxdateobs} = 'DATE_OBS';
    end
    
    for kk = 1:length(keys)
        idx = find(strcmp(kwds(:, 1), keys{kk}));
        if (~isempty(idx))
            name = strrep(keys{kk}, '-', '_');
            source.(name) = kwds{idx, 2};
        else
            source = [];
            content = '';
            break
        end
    end
    
end

end
