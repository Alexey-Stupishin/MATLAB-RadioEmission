function mfoFieldSaveBoxIndex(data, index, filenamesav)

[~, ~, ~, ~, ~, B] = fpuFieldVal(data);
BX = permute(B.y, [2 1 3]);
BY = permute(B.x, [2 1 3]);
BZ = permute(B.z, [2 1 3]);

exec = 'iouData2SAV(filenamesav, ''BX'', ''BY'', ''BZ''';
fn = fieldnames(index);
for k = 1:length(fn)
    fval = index.(fn{k});
    fname = upper(fn{k});
    eval([fname '=' num2str(fval)]);
    exec = [exec ', ''' fname ''''];
end

exec = [exec ');'];
eval(exec);

end
