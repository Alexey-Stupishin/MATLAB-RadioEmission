function sf_init(hObject, handles, varargin)

global sf_types_set sf_types_set_string 
global sf_types_proj sf_types_proj_string 
global sf_types_how  sf_types_how_string
global sf_types_colormap sf_types_colormap_string
global sf_types_filter sf_types_filter_string
global sf_types_filter_mode sf_types_filter_mode_string
global sf_types_FOV sf_types_FOV_string

handles.output = hObject;

if length(varargin) > 2 && ~isempty(varargin{3})
    set(hObject, 'Name', varargin{3});
end

handles.dim_mode = 1;
handles.comp_mode = 1;
B = varargin{1};
handles.B3 = [];
if isstruct(B)
    handles.dim_mode = 3;
    handles.Bsrc = fpuField2XYZ(B);
    sz1 = size(handles.Bsrc.x);
    handles.sizes = size(handles.Bsrc.z);
else
    sz1 = size(B);
    handles.Bsrc = B;
    handles.sizes = size(B);
end

handles.info = [];
if length(varargin) > 3
    handles.info = varargin{4};
end

handles.D2.Bsrc = [];
if length(varargin) > 1 && ~isempty(varargin{2})
    B = varargin{2};
    
    if isstruct(B)
        handles.D2.Bsrc = fpuField2XYZ(B);
        handles.comp_mode = 2;
    else
        handles.D2.Bsrc = B;
    end
    
    sz2 = size(handles.D2.Bsrc.x);
    if length(sz1) ~= length(sz2)
        error('incompatible sizes!');
    end
    if ~all(sz1 == sz2)
        disp('truncated!');
        szn = min([sz1; sz2]);
        
        handles.Bsrc.x = handles.Bsrc.x(1:szn(1), 1:szn(2), 1:szn(3));
        handles.Bsrc.y = handles.Bsrc.y(1:szn(1), 1:szn(2), 1:szn(3));
        handles.Bsrc.z = handles.Bsrc.z(1:szn(1), 1:szn(2), 1:szn(3));
        handles.sizes = size(handles.Bsrc);

        B.x = B.x(1:szn(1), 1:szn(2), 1:szn(3));
        B.y = B.y(1:szn(1), 1:szn(2), 1:szn(3));
        B.z = B.z(1:szn(1), 1:szn(2), 1:szn(3));
    end
    
    handles.D2.info = [];
    if length(varargin) > 4
        handles.D2.info = varargin{5};
    end
end

handles.szWrk = handles.sizes;
handles.Bwrk = handles.Bsrc;
handles.D2.Bwrk = handles.D2.Bsrc;

if handles.dim_mode == 3
    handles = sf_create_metrics(handles);
end
handles.bound_shift = [0 0 0];

if length(varargin) > 2
    set(hObject, 'Name', varargin{3});
end

k = 1;
% filter dataset
s = 'data_1';         sf_types_set.(s) = k;  sf_types_set_string{k} = s; k = k + 1;
if handles.comp_mode == 1
    set(handles.popupmenu_dataset, 'Enable', 'off');
else
    s = 'data_2';         sf_types_set.(s) = k;  sf_types_set_string{k} = s; k = k + 1;
    s = 'delta';          sf_types_set.(s) = k;  sf_types_set_string{k} = s; k = k + 1;
end
set(handles.popupmenu_dataset, 'String', sf_types_set_string);

k = 1;
s = 'XY';             sf_types_proj.(s) = k;  sf_types_proj_string{k} = s; k = k + 1;
if handles.dim_mode == 1
    set(handles.popupmenu_proj, 'Enable', 'off');
else
    s = 'XZ';          sf_types_proj.(s) = k;  sf_types_proj_string{k} = s; k = k + 1;
    s = 'YZ';          sf_types_proj.(s) = k;  sf_types_proj_string{k} = s; k = k + 1;
end
set(handles.popupmenu_proj, 'String', sf_types_proj_string);

sf_set_allowed_types(handles, 'B');

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

set(handles.popupmenu_how, 'String', sf_types_how_string);
set(handles.popupmenu_colormap, 'String', sf_types_colormap_string);
set(handles.popupmenu_filter_mode, 'String', sf_types_filter_mode_string);
set(handles.popupmenu_filter_type, 'String', sf_types_filter_string);
set(handles.popupmenu_trim, 'String', sf_types_FOV_string);
set(handles.edit_Z_max, 'String', '10');
set(handles.edit_filter_value, 'String', '1500');
set(handles.edit_filter_value_rel, 'String', '10');
set(handles.edit_levels, 'String', '15');
set(handles.edit_label_each, 'String', '3');
set(handles.edit_boundary, 'String', '0.1');

minp = 1;
if size(handles.Bsrc.x, 3) == 1
    maxp = 100;
    set(handles.slider1, 'Visible', 'off');
else
    maxp = size(handles.Bsrc.x, 3);
end
step = 1/(maxp-minp);
val = minp;
set(handles.slider1, 'Min',minp, 'Max',maxp, 'SliderStep',step*[1 10], 'Value',val);

if handles.comp_mode == 2
    set(handles.popupmenu_dataset, 'Value', sf_types_set.delta);
    set(handles.popupmenu_how, 'Value', sf_types_how.Image);
    set(handles.popupmenu_colormap, 'Value', sf_types_colormap.Asymm_Red_Blue);
else
    set(handles.popupmenu_colormap, 'Value', sf_types_colormap.Parula);
end

handles.Bfilt = [];
handles.trim = [];
handles.trimdata.LT = [];
handles.trimdata.RB = [];

fstate = pick(isempty(handles.Bfilt), 'off', 'on');
set(handles.checkbox_filter, 'Enable', fstate);
set(handles.edit_filter_value, 'Enable', fstate);
set(handles.edit_filter_value_rel, 'Enable', fstate);
set(handles.popupmenu_filter_mode, 'Enable', fstate);
set(handles.pushbutton_filter_up, 'Enable', fstate);
set(handles.pushbutton_filter_down, 'Enable', fstate);
set(handles.checkbox_filter_common_val, 'Enable', fstate);
set(handles.popupmenu_filter_type, 'Enable', fstate);

handles = sf_update_proj(handles, false);

warning('off', 'MATLAB:contour:ConstantData');
sf_update_view(handles, pick(handles.comp_mode == 2, 'TOP', 'CAMERA'));

end
