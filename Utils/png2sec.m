function png2sec(fdir)

cnt = 0;
listing = dir(fdir);
for k = 1:length(listing)
    if ~listing(k).isdir && length(listing(k).name) > 4 && strcmp(listing(k).name(end-3:end), '.png')
        fname = ['pic' num2str(cnt, '%06d') '.png'];
        copyfile(fullfile(fdir, listing(k).name), fullfile(fdir, fname));
        cnt = cnt + 1;
    end
end

end
