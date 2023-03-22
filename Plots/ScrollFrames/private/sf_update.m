function sf_update(handles)

global sf_types_what sf_types_how sf_types_filter sf_types_filter_mode sf_types_FOV

what = get(handles.popupmenu_what, 'Value');
p.how = get(handles.popupmenu_how, 'Value');
qcond = ~isempty(handles.B3) && p.how == sf_types_how.Image && (what == sf_types_what.B || what == sf_types_what.Bz);
set(handles.checkbox_quiver, 'Enable', pick(qcond, 'on', 'off'));
if ~qcond
    set(handles.checkbox_quiver, 'Value', 0);
end

switch what
    case sf_types_what.B
        p.B = handles.B;
    case sf_types_what.Bx
        p.B = handles.B3.x;
    case sf_types_what.By
        p.B = handles.B3.y;
    case sf_types_what.Bz
        p.B = handles.B3.z;
end

p.level = round(get(handles.slider1, 'Value'));
set(handles.text_level, 'String', num2str(p.level));
p.common_scale = get(handles.checkbox_common_scale, 'Value');
p.common_color = get(handles.checkbox_common_color, 'Value');
p.colormap = get(handles.popupmenu_colormap, 'Value');

p.filter = (get(handles.checkbox_filter, 'Value') == 1);
p.filter_value_mode = get(handles.popupmenu_filter_mode, 'Value');
set(handles.popupmenu_filter_mode, 'Enable', pick(p.filter, 'on', 'off'));
set(handles.edit_filter_value, 'Enable', pick(p.filter & p.filter_value_mode == sf_types_filter_mode.Abs, 'on', 'off'));
set(handles.edit_filter_value_rel, 'Enable', pick(p.filter & p.filter_value_mode == sf_types_filter_mode.Rel, 'on', 'off'));
set(handles.checkbox_filter_common_val, 'Enable', pick(p.filter & p.filter_value_mode == sf_types_filter_mode.Rel, 'on', 'off'));
set(handles.pushbutton_filter_up, 'Enable', pick(p.filter, 'on', 'off'));
set(handles.pushbutton_filter_down, 'Enable', pick(p.filter, 'on', 'off'));
set(handles.checkbox_filter_common_val, 'Enable', pick(p.filter, 'on', 'off'));
set(handles.popupmenu_filter_type, 'Enable', pick(p.filter, 'on', 'off'));

if p.filter
    if p.filter_value_mode == sf_types_filter_mode.Abs
        p.filter_value = str2double(get(handles.edit_filter_value, 'String'));
    else
        p.filter_value = str2double(get(handles.edit_filter_value_rel, 'String'))/100;
    end
    p.filter_common_val = get(handles.checkbox_filter_common_val, 'Value');
    ftype = get(handles.popupmenu_filter_type, 'Value');
    p.filter_replace = pick(ftype == sf_types_filter.Zero, 0, pick(ftype == sf_types_filter.One, 1, NaN));
end

p.az = str2double(get(handles.text_az, 'String'));
p.el = str2double(get(handles.text_el, 'String'));

p.trim = [];

p.Bq1 = [];
p.Bq2 = [];
if get(handles.checkbox_quiver, 'Value')
    switch what
        case sf_types_what.B
            p.Bq1 = handles.B3.x;
            p.Bq2 = handles.B3.y;
        case sf_types_what.Bx
            p.Bq1 = handles.B3.y;
            p.Bq2 = handles.B3.z;
        case sf_types_what.By
            p.Bq1 = handles.B3.z;
            p.Bq2 = handles.B3.x;
        case sf_types_what.Bz
            p.Bq1 = handles.B3.x;
            p.Bq2 = handles.B3.y;
    end
end
p.Bfilt = handles.Bfilt;

p.levels = str2double(get(handles.edit_levels, 'String'));
p.label_each = str2double(get(handles.edit_label_each, 'String'));

p.trim = handles.trim;
p.trimdata.LT = handles.trimdata.LT;
p.trimdata.RB = handles.trimdata.RB;
isTrim = ~isempty(handles.trim);
if ~isTrim
    set(handles.popupmenu_trim, 'Value', sf_types_FOV.Full_FOV);
end
tstate = pick(isTrim, 'on', 'off');
set(handles.popupmenu_trim, 'Enable', tstate);
p.trim_draw = get(handles.popupmenu_trim, 'Value') == sf_types_FOV.Trim;

setappdata(handles.axes1, 'trim', p.trim_draw);
setappdata(handles.axes1, 'az', p.az);
setappdata(handles.axes1, 'el', p.el);

p = sf_draw(handles.axes1, p);

if ~isempty(p.maxBCommon.val)
    set(handles.edit_value_abs_total, 'String', num2str(p.maxBCommon.val, '%6.1f'));
end
if ~isempty(p.maxBbyLevel.val)
    set(handles.edit_value_abs_level, 'String', num2str(p.maxBbyLevel.val(p.level), '%6.1f'));
    if ~isempty(p.maxBCommon.val)
        set(handles.edit_value_rel_level, 'String', num2str(p.maxBbyLevel.val(p.level)/p.maxBCommon.val*100, '%5.1f'));
    end
end

view(handles.axes1, p.az, p.el);

end
