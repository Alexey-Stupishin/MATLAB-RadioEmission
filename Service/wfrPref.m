function val = wfrPref(group, item, value, mode)

if (~exist('mode', 'var'))
    mode = 'save';
end

spem = which('wfrPref.m');
path = fileparts(spem); 
sPrefFile = fullfile(path, 'wfrPref.mat');

if ~exist(sPrefFile, 'file')
    pref = struct();
else
    pref = load(sPrefFile);
end

val = '';
if (~strcmp(mode, 'save'))
    val = value;
end
if (isfield(pref, group) && isfield(pref.(group), item))
    val = pref.(group).(item);
end

if (strcmp(mode, 'save'))
    pref.(group).(item) = value;
    save(sPrefFile, '-struct', 'pref');
end

end
