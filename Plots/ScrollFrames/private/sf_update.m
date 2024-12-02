function sf_update(handles)

global sf_types_what_string sf_types_how sf_types_filter sf_types_filter_mode sf_types_FOV sf_types_what_quiver sf_types_proj

what = get(handles.popupmenu_what, 'Value');
p.how = get(handles.popupmenu_how, 'Value');
qcond = p.how == sf_types_how.Image && ~isempty(sf_types_what_quiver{what});
set(handles.checkbox_quiver, 'Enable', pick(qcond, 'on', 'off'));
if ~qcond
    set(handles.checkbox_quiver, 'Value', 0);
end

p.Bq1 = [];
p.Bq2 = [];
type = sf_types_what_string{what};
if handles.dim_mode == 1
    p.B = sf_get_data(handles, what);
elseif ~any(strcmp(type, {'Dangle', 'Dresidual'}))
    [p.B, p.Bq1, p.Bq2] = sf_get_data(handles, what);
    if ~get(handles.checkbox_quiver, 'Value')
        p.Bq1 = [];
        p.Bq2 = [];
    end
elseif strcmp(type, 'Dangle')
    p.B = handles.M_angle;
elseif strcmp(type, 'Dresidual')
    p.B = handles.M_res;
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
p.select = handles.select;
p.bound_shift = handles.bound_shift;

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
p.allow_trim = get(handles.popupmenu_proj, 'Value') == sf_types_proj.XY;

setappdata(handles.axes1, 'trim', p.trim_draw);
setappdata(handles.axes1, 'az', p.az);
setappdata(handles.axes1, 'el', p.el);

if ~isempty(p.select)
    set(handles.edit_x, 'String', p.select.xy(2));
    set(handles.edit_y, 'String', p.select.xy(1));
    value = p.B(p.select.xy(1)-p.bound_shift(1), p.select.xy(2)-p.bound_shift(2), p.level);
    set(handles.edit_val, 'String', value, 'ForegroundColor', pick(value > 0, 'b', 'r'));
else
    set(handles.edit_x, 'String', []);
    set(handles.edit_y, 'String', []);
    set(handles.edit_val, 'String', []);
end

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

az = p.az;
el = p.el;
if p.how ~= sf_types_how.Surface
    az = 0;
    el = 90;
end
view(handles.axes1, az, el);
drawnow

end
