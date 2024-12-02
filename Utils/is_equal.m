function is_equal(a, b)

fnames = fieldnames(a);
for k = 1:length(fnames)
    iseq = all(all(all(a.(fnames{k})-b.(fnames{k}) == 0)));
    disp([fnames{k} ' ' num2str(iseq)])
end

end
