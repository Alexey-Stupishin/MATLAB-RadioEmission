function asuShowDirContent(path)

disp(path)
l_show(path, 1);

end

%--------------------------------------------------------------------------
function l_show(path, lev)

shift = repmat(char(9), [1 lev]);
listing = dir(path);
for k = 1:length(listing)
    if ~any(strcmp(listing(k).name, {'.', '..'}))
        disp([shift listing(k).name])
        if listing(k).isdir
            l_show([path '\' listing(k).name], lev+1);
        end
    end
end

end
