function [vv, dtime] = jetGetSequenceSav(fdir, mask)

listing = dir(fdir);
exclude = [];
for k = 1:length(listing)
    if listing(k).isdir
        exclude = [exclude k];
        continue
    end
    if isempty(strfind(listing(k).name, mask))
        exclude = [exclude k];
    end
end
listing(exclude) = [];

vv = [];
dtime = cell(1, length(listing));
for k = 1:length(listing)
    fname = fullfile(fdir, listing(k).name);
    d = iouSAV2Data(fname);
    
    v = d.DATA_OUT';
    
    if isempty(vv)
        vv = zeros(size(v, 1), size(v, 2), length(listing));
    end
    
    vv(:, :, k) = v;
    
    dt = d.DATE_OBS;
    dt = strrep(dt, 'T', ' ');
    dt = dt(1:end-2);
    dtime{k} = dt;
end

end