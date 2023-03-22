function jetCompareSeqsBatch(root, subpath1, subpath2, todir)

mask = '_aia';
rate = 5;

mkdir(todir);

tIDw = tic;

listing = dir(root);
for k = 1:length(listing)
    if ~listing(k).isdir
        continue
    end
    if strcmp(listing(k).name, '.') || strcmp(listing(k).name, '..')
        continue
    end
    
    dir1 = fullfile(root, listing(k).name, subpath1);
    dir2 = fullfile(root, listing(k).name, subpath2);
    n1 = l_cnt(dir1, mask);
    n2 = l_cnt(dir2, mask);
    if n1 > 0 && n2 > 0 % n1 == n2
        tID = tic;
        outdir = fullfile(todir, listing(k).name);
        mkdir(outdir);
        jetCompareSeqs(dir1, 0, dir2, 0, mask, outdir);
        outfile = fullfile(todir, [listing(k).name '_compare.mp4']);
        fullmask = fullfile(outdir, [mask '%05d.png']);
        ffmpeg(rate, fullmask, outfile)
        disp([listing(k).name ': ' srvSecToDisp(toc(tID))]);
    end
end

disp(['Batch : ' srvSecToDisp(toc(tIDw))]);

end

%--------------------------------------------------------------------------
function n = l_cnt(indir, mask)

listing = dir(indir);
n = 0;
for k = 1:length(listing)
    if ~listing(k).isdir
        outs = regexp(listing(k).name, ['.*' mask '([0-9]*).png'], 'tokens');
        if ~isempty(outs{1}) && ~isempty(outs{1}{1})
            n = n + 1;
        end
    end
end

end
