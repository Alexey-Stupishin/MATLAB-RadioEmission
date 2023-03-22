function iouSST4amb(sst, todir)

d = sst.MFODATA;

step = 1;

% parse d.OBSTIME
date = '2000-01-01';
time = '00:00:00';

mfrdata = obs2mfrdata(d.BX(:,:,1), d.BY(:,:,1), d.BZ(:,:,1), date, time, [0 0], [d.DX_ARC d.DY_ARC], d.R_ARC, [step step], true);

fname = [todir, '\', d.FILEID, '.hmi'];
mfrdata.specification.filename = fname;

save(fname, '-struct', 'mfrdata');

end
