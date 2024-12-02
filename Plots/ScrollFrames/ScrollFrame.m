function varargout = ScrollFrame(varargin)
% Last Modified by GUIDE v2.5 18-May-2024 23:56:51
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
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
    sf_update_view(handles, 'CAMERA');
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
function edit_Z_max_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function edit_label_each_Callback(hObject, eventdata, handles)
sf_update(handles);

%--------------------------------------------------------------------------
function axes1_ButtonDownFcn(hObject, eventdata, handles)
if eventdata.Button == 1
    sf_update_trim(handles, hObject);
elseif eventdata.Button == 3
    sf_get_point_value(handles, eventdata.IntersectionPoint);
end

%--------------------------------------------------------------------------
function pushbutton_clear_value_Callback(hObject, eventdata, handles)
sf_get_point_value(handles, []);

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

function pushbutton_camera_view_Callback(hObject, eventdata, handles)
sf_update_view(handles, 'CAMERA');

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
function popupmenu_dataset_Callback(hObject, eventdata, handles)
global sf_types_what_string 
idx_what = get(handles.popupmenu_what, 'Value');
sf_set_allowed_types(handles, sf_types_what_string{idx_what});
%sf_update_view(handles, 'SIDE');
sf_update(handles);

%--------------------------------------------------------------------------
function pushbutton_up_Callback(hObject, eventdata, handles)
sf_move(handles, 1, 1);

%--------------------------------------------------------------------------
function pushbutton_down_Callback(hObject, eventdata, handles)
sf_move(handles, 1, -1);

%--------------------------------------------------------------------------
function pushbutton_left_Callback(hObject, eventdata, handles)
sf_move(handles, 2, -1);

%--------------------------------------------------------------------------
function pushbutton_right_Callback(hObject, eventdata, handles)
sf_move(handles, 2, 1);

%--------------------------------------------------------------------------
function figure1_KeyPressFcn(hObject, eventdata, handles)
if strcmp(eventdata.Key, 'uparrow')
    crd = 1; dir = 1;
elseif strcmp(eventdata.Key, 'downarrow')
    crd = 1; dir = -1;
elseif strcmp(eventdata.Key, 'rightarrow')
    crd = 2; dir = 1;
% if strcmp(eventdata.Key, 'uparrow')
else
    crd = 2; dir = -1;
end
sf_move(handles, crd, dir);

%--------------------------------------------------------------------------
function checkbox_boundary_Callback(hObject, eventdata, handles)
sf_update_boundary(handles)

%--------------------------------------------------------------------------
function edit_boundary_Callback(hObject, eventdata, handles)
sf_update_boundary(handles)

%--------------------------------------------------------------------------
function pushbutton_report_Callback(hObject, eventdata, handles)
sf_report(handles)

%--------------------------------------------------------------------------
function popupmenu_proj_Callback(hObject, eventdata, handles)
sf_update_proj(handles, true)

%--------------------------------------------------------------------------
%**************************************************************************
function figure1_KeyReleaseFcn(hObject, eventdata, handles)

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

function edit_Z_max_CreateFcn(hObject, eventdata, handles)
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



function range_from_Callback(hObject, eventdata, handles)
% hObject    handle to range_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_from as text
%        str2double(get(hObject,'String')) returns contents of range_from as a double


% --- Executes during object creation, after setting all properties.
function range_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_to_Callback(hObject, eventdata, handles)
% hObject    handle to range_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_to as text
%        str2double(get(hObject,'String')) returns contents of range_to as a double


% --- Executes during object creation, after setting all properties.
function range_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_from_rel_Callback(hObject, eventdata, handles)
% hObject    handle to range_from_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_from_rel as text
%        str2double(get(hObject,'String')) returns contents of range_from_rel as a double


% --- Executes during object creation, after setting all properties.
function range_from_rel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_from_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_to_rel_Callback(hObject, eventdata, handles)
% hObject    handle to range_to_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_to_rel as text
%        str2double(get(hObject,'String')) returns contents of range_to_rel as a double


% --- Executes during object creation, after setting all properties.
function range_to_rel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_to_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_dataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_val_Callback(hObject, eventdata, handles)
% hObject    handle to edit_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_val as text
%        str2double(get(hObject,'String')) returns contents of edit_val as a double


% --- Executes during object creation, after setting all properties.
function edit_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y as text
%        str2double(get(hObject,'String')) returns contents of edit_y as a double


% --- Executes during object creation, after setting all properties.
function edit_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_boundary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_boundary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_proj_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_levels_Callback(hObject, eventdata, handles)


function edit_levels_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
