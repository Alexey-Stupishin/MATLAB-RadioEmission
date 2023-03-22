function fn = srvStr2Filename(str)

fn = regexprep(str, '[ \\|/?<>"*.]+', '_');
fn = strrep(fn, ':', '_');
 
end
