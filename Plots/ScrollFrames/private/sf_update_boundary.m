function sf_update_boundary(handles)

sz = handles.szWrk;

if ~get(handles.checkbox_boundary, 'Value')
    bounds.x = 1:sz(1);
    bounds.y = 1:sz(2);
    if handles.dim_mode == 3
        bounds.z = 1:sz(3);
    end
    on_c = [0 0 0];
else
    v = str2double(get(handles.edit_boundary, 'String'));
    on_c = ceil(sz*v);
    bounds.x = (on_c(1)+1):(sz(1)-on_c(1));
    bounds.y = (on_c(2)+1):(sz(2)-on_c(2));
    bounds.z = 1:(sz(3)-on_c(3));
end

handles.bound_shift = [on_c(1:2) 0];

handles = sf_create_metrics(handles, bounds);

% handles.trim = [];
% handles.select = [];

guidata(gcbf, handles);
sf_update(handles);

end
