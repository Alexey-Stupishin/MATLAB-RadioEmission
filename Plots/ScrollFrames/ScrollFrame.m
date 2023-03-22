function varargout = ScrollFrame(varargin)
% Last Modified by GUIDE v2.5 10-Oct-2021 08:42:43
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScrollFrame_OpeningFcn, ...
                   'gui_OutputFcn',  @ScrollFrame_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%--------------------------------------------------------------------------
function ScrollFrame_OpeningFcn(hObject, eventdata, handles, varargin)
sf_init(hObject, handles, varargin{:});

%--------------------------------------------------------------------------
function varargout = ScrollFrame_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%--------------------------------------------------------------------------
function slider1_Callback(hObject, eventdata, handles)
sf_update(handles);

% ----------------- SHOW --------------------------------------------------
%--------------------------------------------------------------------------
function popupmenu_what_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function popupmenu_how_Callback(hObject, eventdata, handles)
global sf_types_colormap sf_types_how

v = get(hObject, 'Value');
switch v
    case sf_types_how.Surface
        set(handles.popupmenu_colormap, 'Value', sf_types_colormap.Parula);
    otherwise
        set(handles.popupmenu_colormap, 'Value', sf_types_colormap.Asymm_Red_Blue);
end

if v == sf_types_how.Surface
    sf_update_view(handles, 'SIDE');
else
    sf_update_view(handles, 'TOP');
end

%--------------------------------------------------------------------------
function checkbox_common_scale_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function checkbox_quiver_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function checkbox_common_color_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function popupmenu_colormap_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function edit_levels_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function edit_label_each_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function axes1_ButtonDownFcn(hObject, eventdata, handles)
sf_update_trim(handles, hObject);

%--------------------------------------------------------------------------
function popupmenu_trim_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function pushbutton_trim_delete_Callback(hObject, eventdata, handles)
sf_update_trim(handles);

% ----------------- VIEW --------------------------------------------------
%--------------------------------------------------------------------------
function pushbutton_az_d_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'AZ', 'D');

%--------------------------------------------------------------------------
function pushbutton_az_dd_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'AZ', 'DD');

%--------------------------------------------------------------------------
function pushbutton_az_u_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'AZ', 'U');

%--------------------------------------------------------------------------
function pushbutton_az_uu_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'AZ', 'UU');

%--------------------------------------------------------------------------
function pushbutton_el_d_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'EL', 'U');

%--------------------------------------------------------------------------
function pushbutton_el_dd_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'EL', 'UU');

%--------------------------------------------------------------------------
function pushbutton_el_u_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'EL', 'D');

%--------------------------------------------------------------------------
function pushbutton_el_uu_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'EL', 'DD');

%--------------------------------------------------------------------------
function pushbutton_top_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'TOP');

%--------------------------------------------------------------------------
function pushbutton_side_view_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'SIDE');

% ----------------- FILTER ------------------------------------------------
%--------------------------------------------------------------------------
function checkbox_filter_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function popupmenu_filter_mode_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function edit_filter_value_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function edit_filter_value_rel_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function pushbutton_filter_up_Callback(hObject, eventdata, handles)
sf_update_filter(handles, 1);

%--------------------------------------------------------------------------
function pushbutton_filter_down_Callback(hObject, eventdata, handles)
sf_update_filter(handles, -1);

%--------------------------------------------------------------------------
function checkbox_filter_common_val_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function popupmenu_filter_type_Callback(hObject, eventdata, handles)
sf_update(handles);

% ----------------- FRAMES ------------------------------------------------
%--------------------------------------------------------------------------
function pushbutton_prev_Callback(hObject, eventdata, handles)
sf_move(handles, -1);

%--------------------------------------------------------------------------
function pushbutton_next_Callback(hObject, eventdata, handles)
sf_move(handles, 1);

%--------------------------------------------------------------------------
%**************************************************************************
function edit_value_abs_total_Callback(hObject, eventdata, handles)

function edit_value_abs_level_Callback(hObject, eventdata, handles)

function edit_value_rel_level_Callback(hObject, eventdata, handles)

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function popupmenu_what_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_how_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_colormap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_levels_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_label_each_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_filter_value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_filter_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_trim_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_filter_value_rel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_value_abs_total_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_value_abs_level_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_value_rel_level_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_filter_mode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%--------------------------------------------------------------------------
