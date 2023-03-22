h = findall(0, 'Type', 'figure');
hm = findall(0, 'Type', 'figure','Tag', 'MD3_MainWindow');
hamb = findall(0, 'Type', 'figure','Tag', 'AGS_AmbigityMain');
if ~isempty(hm)
    h(h == hm) = [];
end
if ~isempty(hamb)
    h(h == hamb) = [];
end
delete(h)
