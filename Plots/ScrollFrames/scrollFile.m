function scrollFile(fname, fname2)

defPath = wfrPref('Outfiles', 'defPath', 's:\UData\', 'load');
if ~exist('fname', 'var')
    [fn, pn] = uigetfile({'*.sav', 'SAV (sst) Files (*.sav)'; '*.out', 'OUT Files (*.out)'; '*.*', 'All Files (*.*)'}, 'Choose Any Binary File', [defPath '*.sav']);
    if fn == 0
        return
    end
    fname = fullfile(pn, fn);
    wfrPref('Outfiles', 'defPath', pn);
else
    pn = fileparts(fname);
end

if ~exist('fname2', 'var')
    fname2 = '';
    [fn2, pn2] = uigetfile({'*.sav', 'SAV (sst) Files (*.sav)'; '*.out', 'OUT Files (*.out)'; '*.*', 'All Files (*.*)'}, 'Choose Any Binary File', [pn '*.sav']);
    if fn2 ~= 0
        fname2 = fullfile(pn2, fn2);
    end
end

B = l_getB(fname);

if ~isempty(fname2)
    B2 = l_getB(fname2);
    B.x = B.x - B2.x;
    B.y = B.y - B2.y;
    B.z = B.z - B2.z;
end

ScrollFrame(B);

end

%--------------------------------------------------------------------------
function B = l_getB(fname)

mfoData = mfoLoadField(fname);
B = mfoData.B;

end
