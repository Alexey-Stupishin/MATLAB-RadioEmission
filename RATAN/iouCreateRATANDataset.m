function data = iouCreateRATANDataset(fdir, maskp, maskc, maske)

data = [];

listing = dir(fdir);
for k = 1:length(listing)
    if listing(k).isdir
        continue
    end
    
    outs = regexp(listing(k).name, [maskp '.+az([\d+-]+)_(SCANS|SPECTRA)' maskc '(stille|lin)' maske], 'tokens');
    if ~isempty(outs)
        t.az = str2num(outs{1}{1});
        t.fullname = fullfile(fdir, listing(k).name);
        if ~isfield(data, outs{1}{3})
            data.(outs{1}{3}) = [];
        end
        if ~isfield(data.(outs{1}{3}), outs{1}{2})
            data.(outs{1}{3}).(outs{1}{2}) = [];
        end
        data.(outs{1}{3}).(outs{1}{2}) = [data.(outs{1}{3}).(outs{1}{2}) t];
    end
end

end
