function iouXYZ4amb(xyz_file, todir)

global mfrdata

d = iouSAV2Data(xyz_file);
dx = 1;
dy = 1;
R = 960;
step = 1;
date = '2000-01-01';
time = '00:00:00';

[dir, name] = fileparts(xyz_file);

if ~exist('todir', 'var')
    todir = dir;
end

mfrdata = obs2mfrdata(d.BOX.BX(:,:,1), d.BOX.BY(:,:,1), d.BOX.BZ(:,:,1), date, time, [0 0], [dx dy], R, [step step], true);

fname = [todir, '\', name, '.hmi'];
mfrdata.specification.filename = fname;

save(fname, '-struct', 'mfrdata');

end
