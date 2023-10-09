function s = idl_conv2struct(idl)

n = length(idl);
t = cell2struct(idl, 't', n);
s = [t.t];

end
