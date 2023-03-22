function jetCompareSeqs(dir1, frame1, dir2, frame2, mask, todir)

list1 = l_getList(dir1, mask, frame1);
list2 = l_getList(dir2, mask, frame2);

for k = 1:min(length(list1), length(list2))
    [C1, map1] = imread(fullfile(dir1, list1(k).name));
    s1 = size(C1);
    [C2, map2] = imread(fullfile(dir2, list2(k).name));
    s2 = size(C2);
    CC = uint8(255*ones(s1(1)+s2(1), max(s1(2), s2(2)), 3));
    CC(1:s1(1), 1:s1(2), :) = C1;
    CC(s1(1)+(1:s2(1)), 1:s2(2), :) = C2;
    fname = fullfile(todir, [mask num2str(k, '%05d') '.png']);
    imwrite(CC, fname);
end

end

%--------------------------------------------------------------------------
function listing = l_getList(fdir, mask, frame)

listing = dir(fdir);
exclude = [];
for k = 1:length(listing)
    if listing(k).isdir
        exclude = [exclude k];
        continue
    end
    if isempty(strfind(listing(k).name, mask))
        exclude = [exclude k];
        continue
    end
    outs = regexp(listing(k).name, ['.*' mask '([0-9]*).png'], 'tokens');
    if isempty(outs{1}{1})
        exclude = [exclude k];
        continue
    end
    n = str2double(outs{1}{1});
    if isnan(n) || n < frame
        exclude = [exclude k];
        continue
    end
end
listing(exclude) = [];

end
