function srvCtrlEnable(hDlg, tag, cond)

h = findobj(hDlg, 'Tag', tag);
if (cond)
    en = 'on';
else
    en = 'off';
end
set(h, 'Enable', en);

end
