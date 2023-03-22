function [filename, loadext] = wfr_getFieldFilename(prefext, title)

filename = '';

if ~exist('prefext', 'var') || length(prefext) ~= 3
    prefext = 'bin';
end

if ~exist('title', 'var')
    title = 'Choose Any Field File';
end

exts = {'bin', 'out', 'sav', 'mat', 'hmi'};        
filters = { '*.bin', 'MMF bin Files (*.bin)'; ...
            '*.out', 'MMF out Files (*.out)'; ...
            '*.sav', 'IDL Save Files (*.sav)'; ...
            '*.mat', 'MATLAB Files (*.mat)'; ...
            '*.hmi', 'HMI MATLAB Files (*.hmi)'; ...
            '*.*', 'All Files (*.*)'};
idx = find(strcmp(prefext, exts));
if isempty(idx)
    idx = 1;
end

if idx > 1
    t = filters(idx, :);
    filters(idx, :) = [];
    filters = [t; filters];
end

defPath = wfrPref('FieldLoad', 'defPath', 's:\UData\', 'load');
[fname, pname] = uigetfile(filters, title, [defPath '*.' prefext]);
if (fname == 0)
    return
end
[~, ~, ext] = fileparts(fname);
loadext = lower(ext(2:end));
wfrPref('FieldLoad', 'defPath', pname);

filename = fullfile(pname, fname);

end
