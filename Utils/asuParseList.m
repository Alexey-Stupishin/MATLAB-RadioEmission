function lst = asuParseList(s, delim)

lst = {s};

if ~exist('delim', 'var')
    delim = ',';
end

pos = strfind(s, delim);

if isempty(pos)
    return
end

lst = cell(1, length(pos)+1);
cpos = 0;
for k = 1:length(pos)
    lst{k} = s(cpos+1:pos(k)-1);
    cpos = pos(k);
end
lst{end} = s(cpos+1:end);

end
