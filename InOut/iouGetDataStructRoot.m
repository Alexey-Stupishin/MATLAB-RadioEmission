function s = iouGetDataStructRoot(sbase)

if (~exist('sbase', 'var'))
    sbase = [];
end

s.TELESCOP = '';
s.INSTRUME = '';
s.OBS_DATE = '';
s.OBS_TIME = '';
s = iouGetDataStructBase(s);
       
if (isstruct(sbase))
    s = iouCopyStructFields(s, sbase);
end

end