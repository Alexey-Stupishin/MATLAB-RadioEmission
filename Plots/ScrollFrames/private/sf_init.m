function sf_init(hObject, handles, varargin)

global sf_types_what sf_types_what_string 
global sf_types_how  sf_types_how_string
global sf_types_colormap sf_types_colormap_string
global sf_types_filter sf_types_filter_string
global sf_types_filter_mode sf_types_filter_mode_string
global sf_types_FOV sf_types_FOV_string

k = 1;
s = 'B';                sf_types_what.(s) = k;  sf_types_what_string{k} = s; k = k + 1;
s = 'Bx';               sf_types_what.(s) = k;  sf_types_what_string{k} = s; k = k + 1;
s = 'By';               sf_types_what.(s) = k;  sf_types_what_string{k} = s; k = k + 1;
s = 'Bz';               sf_types_what.(s) = k;  sf_types_what_string{k} = s; k = k + 1;

k = 1;
s = 'Surface';          sf_types_how.(s) = k;  sf_types_how_string{k} = s; k = k + 1;
s = 'Image';            sf_types_how.(s) = k;  sf_types_how_string{k} = s; k = k + 1;
s = 'Contour';          sf_types_how.(s) = k;  sf_types_how_string{k} = s; k = k + 1;

k = 1;
s = 'Asymm_Red_Blue';   sf_types_colormap.(s) = k;  sf_types_colormap_string{k} = s; k = k + 1;
s = 'Parula';           sf_types_colormap.(s) = k;  sf_types_colormap_string{k} = s; k = k + 1;

k = 1;
s = 'Zero';             sf_types_filter.(s) = k;  sf_types_filter_string{k} = '0'; k = k + 1;
s = 'One';              sf_types_filter.(s) = k;  sf_types_filter_string{k} = '1'; k = k + 1;
s = 'NaN';              sf_types_filter.(s) = k;  sf_types_filter_string{k} = s; k = k + 1;

k = 1;
s = 'Rel';              sf_types_filter_mode.(s) = k;  sf_types_filter_mode_string{k} = s; k = k + 1;
s = 'Abs';              sf_types_filter_mode.(s) = k;  sf_types_filter_mode_string{k} = s; k = k + 1;

k = 1;
s = 'Full_FOV';         sf_types_FOV.(s) = k;  sf_types_FOV_string{k} = s; k = k + 1;
s = 'Trim';             sf_types_FOV.(s) = k;  sf_types_FOV_string{k} = s; k = k + 1;

handles.output = hObject;
B = varargin{1};
if isfield(B, 'BX')
    b.x = B.BX;
    b.y = B.BY;
    b.z = B.BZ;
    B = b;
end
handles.B3 = [];
if isstruct(B)
    handles.B3 = B;
    handles.B = fpuFieldVal(B);
else
    handles.B = B;
end
handles.Bbase = handles.B;
handles.B3base = handles.B3;
handles.Bfilt = [];
if length(varargin) > 1 && ~isempty(varargin{2})
    handles.Bfilt = varargin{2};
end
handles.trimdata.LT = [];
handles.trimdata.RB = [];
handles.trim = [];
guidata(hObject, handles);
if length(varargin) > 2
 set(hObject, 'Name', varargin{3});
end

allow = sf_types_what_string;
if isempty(handles.B3)
    allow = allow(1);
end
set(handles.popupmenu_what, 'String', allow);
set(handles.popupmenu_how, 'String', sf_types_how_string);
set(handles.popupmenu_colormap, 'String', sf_types_colormap_string);
set(handles.popupmenu_filter_mode, 'String', sf_types_filter_mode_string);
set(handles.popupmenu_filter_type, 'String', sf_types_filter_string);
set(handles.popupmenu_trim, 'String', sf_types_FOV_string);
set(handles.edit_filter_value, 'String', '1500');
set(handles.edit_filter_value_rel, 'String', '10');
set(handles.edit_levels, 'String', '15');
set(handles.edit_label_each, 'String', '3');

minp = 1;
if size(handles.B, 3) == 1
    maxp = 100;
    set(handles.slider1, 'Visible', 'off');
else
    maxp = size(handles.B, 3);
end
step = 1/(maxp-minp);
val = minp;
set(handles.slider1, 'Min',minp, 'Max',maxp, 'SliderStep',step*[1 10], 'Value',val);

set(handles.popupmenu_colormap, 'Value', sf_types_colormap.Parula);

fstate = pick(isempty(handles.Bfilt), 'off', 'on');
set(handles.checkbox_filter, 'Enable', fstate);
set(handles.edit_filter_value, 'Enable', fstate);
set(handles.edit_filter_value_rel, 'Enable', fstate);
set(handles.popupmenu_filter_mode, 'Enable', fstate);
set(handles.pushbutton_filter_up, 'Enable', fstate);
set(handles.pushbutton_filter_down, 'Enable', fstate);
set(handles.checkbox_filter_common_val, 'Enable', fstate);
set(handles.popupmenu_filter_type, 'Enable', fstate);

warning('off', 'MATLAB:contour:ConstantData');
sf_update_view(handles, 'SIDE');

end
