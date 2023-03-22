function listing = asuGetDirContent(this_dir, content)

if ~exist('content', 'var') || isempty(content)
    content = 'all';
end

listing = dir(this_dir);
exclude = [];
for k = 1:length(listing)
    if listing(k).isdir
        if any(strcmp(listing(k).name, {'.', '..'})) || strcmp(content, 'files')
            exclude = [exclude k];
        end
    else
        if strcmp(content, 'dirs')
            exclude = [exclude k];
        end
    end
end
listing(exclude) = [];

end
