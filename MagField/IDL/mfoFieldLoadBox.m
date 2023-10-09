function B = mfoFieldLoadBox(filename)

if ~exist('filename', 'var') || isempty(filename)
    filename = wfr_getFilename('sav');
end

if isempty(filename)
    return
end
field = iouSAV2Data(filename);

B = mfoFieldGetBox(field);

end
