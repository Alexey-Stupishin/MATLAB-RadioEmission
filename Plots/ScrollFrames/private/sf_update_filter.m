function sf_update_filter(handles, dir)

global sf_types_filter_mode

if ~get(handles.checkbox_filter, 'Value')
    return
end

if get(handles.popupmenu_filter_mode, 'Value') == sf_types_filter_mode.Abs
     h = handles.edit_filter_value;
     s = 100;
else
     h = handles.edit_filter_value_rel;
     s = 5;
end

v = str2double(get(h, 'String'));
v = max(v + sign(dir)*s, 0);
set(h, 'String', num2str(v));

sf_update(handles);

end
