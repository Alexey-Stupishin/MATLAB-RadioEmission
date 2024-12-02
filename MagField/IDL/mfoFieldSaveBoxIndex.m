function mfoFieldSaveBoxIndex(data, index, filenamesav)

[~, ~, ~, ~, ~, B] = fpuFieldVal(data);
BX = permute(B.y, [2 1 3]);
BY = permute(B.x, [2 1 3]);
BZ = permute(B.z, [2 1 3]);

exec = 'iouData2SAV(filenamesav, ''BX'', ''BY'', ''BZ''';
if isfield(data, 'absB')
    absB = permute(data.absB, [2 1 3]);
    exec = [exec ', ''absB'''];
end
if isfield(data, 'incl')
    incl = permute(data.incl, [2 1 3]);
    exec = [exec ', ''incl'''];
end
if isfield(data, 'azim')
    azim = permute(data.azim, [2 1 3]);
    exec = [exec ', ''azim'''];
end
fn = fieldnames(index);
for k = 1:length(fn)
    fval = index.(fn{k});
    if isnumeric(fval)
        fval = num2str(fval);
        fname = upper(fn{k});
        eval([fname '=' fval]);
        exec = [exec ', ''' fname ''''];
    end
end

exec = [exec ');'];
eval(exec);

end
