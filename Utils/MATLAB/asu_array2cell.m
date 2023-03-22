function c = asu_array2cell(a, format)

if ~exist('format', 'var')
    format = '%f';
end

c = cell(1, length(a));
for k = 1:length(a)
    c{k} = num2str(a(k), format);
end

end
