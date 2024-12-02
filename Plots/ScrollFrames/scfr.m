function scfr(two, shift)

if ~exist('two', 'var')
    two = false;
end
if ~exist('shift', 'var')
    shift = [0 0];
end

[filename, fname] = wfr_getFilename('out');
dd = iouAny2Data(filename);
d = fpuField2XYZ(dd);
%s = mfm_report(dd);
s = [];

d2 = [];
s2 = [];
if two
    [filename, f] = wfr_getFilename('out');
    dd2 = iouAny2Data(filename);
    sz1 = size(dd.BZ);
    sz2 = size(dd2.BZ);
    dsz = sz2 - sz1;
    if dsz(1) > 0
        dd2.BX = dd2.BX(shift(1) + (1:sz1(1)), shift(2) + (1:sz1(2)), 1:sz1(3));
        dd2.BY = dd2.BY(shift(1) + (1:sz1(1)), shift(2) + (1:sz1(2)), 1:sz1(3));
        dd2.BZ = dd2.BZ(shift(1) + (1:sz1(1)), shift(2) + (1:sz1(2)), 1:sz1(3));
    end
    d2 = fpuField2XYZ(dd2);
    %s2 = mfm_report(dd2);
    s2 = [];
    fname = [fname ' **vs** ' f];
end

ScrollFrame(d, d2, fname, s, s2);

end
