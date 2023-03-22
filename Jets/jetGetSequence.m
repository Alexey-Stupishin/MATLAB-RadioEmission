function [vv, dtime] = jetGetSequence(fdir, mask)

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
    d = iouBIN2Data(fname);
    v = reshape(d.data, d.N');
    v = v(:, end:-1:1)';
    
    if isempty(vv)
        vv = zeros(size(v, 1), size(v, 2), length(listing));
    end
    
    vv(:, :, k) = v;
    dtime{k} = datestr(datetime(d.year, d.month, d.day, d.hours, d.minutes, d.seconds), 'yyyy-mm-dd hh:MM:ss');
end

end