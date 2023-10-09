function iouXYZ_sst_4amb(xyz_file, todir)

global mfrdata

d = iouSAV2Data(xyz_file);
dx = d.MFODATA.DX_ARC;
dy = d.MFODATA.DY_ARC;
R = d.MFODATA.R_ARC;
center = [d.MFODATA.X_CEN d.MFODATA.Y_CEN];

step = d.MFODATA.DX_ARC;

[date, time] = astDateTimeStrings(d.MFODATA.OBSTIME);

[dir, name] = fileparts(xyz_file);

if ~exist('todir', 'var')
    todir = dir;
end

mfrdata = obs2mfrdata(d.MFODATA.BX(:,:,1), d.MFODATA.BY(:,:,1), d.MFODATA.BZ(:,:,1), date, time, center, [dx dy], R, [step step], true);

fname = [todir, '\', name, '.hmi'];
mfrdata.specification.filename = fname;

save(fname, '-struct', 'mfrdata');

end
