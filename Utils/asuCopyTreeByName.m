function asuCopyTreeByName(dir1, dir2)

listing1 = asuGetDirContent(dir1);
listing2 = asuGetDirContent(dir2);

for k = 1:length(listing1)
    from = [dir1 '\' listing1(k).name];
    to = [dir2 '\' listing1(k).name];
    idx = find(strcmp(listing1(k).name, {listing2.name}), 1);
    if listing1(k).isdir
        if isempty(idx)
            mkdir(to);
            disp(['new dir ' to])
        end
        disp(['dir ' from ' -> ' to])
        asuCopyTreeByName(from, to)
    else
        if isempty(idx)
            copyfile(from, to)
            disp([from ' -> ' to])
        end
    end
end

end
