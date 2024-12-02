function handles = sf_update_proj(handles, upd)

global sf_types_FOV sf_types_proj

set(handles.slider1, 'Value', 1);
set(handles.checkbox_boundary, 'Value', 0);
handles.bound_shift = [0 0 0];
set(handles.popupmenu_trim, 'Value', sf_types_FOV.Full_FOV);
handles.select = [];

v = get(handles.popupmenu_proj, 'Value');
switch v
    case sf_types_proj.XY
        handles.Bwrk = handles.Bsrc;
        handles.D2.Bwrk = handles.D2.Bsrc;
    case sf_types_proj.XZ
        [rx, ry, rz] = l_get_trim(handles);
        B.x = permute(handles.Bsrc.z(rx,ry,rz), [3 1 2]);
        B.y = permute(handles.Bsrc.x(rx,ry,rz), [3 1 2]);
        B.z = permute(handles.Bsrc.y(rx,ry,rz), [3 1 2]);
        handles.Bwrk = B;
        if ~isempty(handles.D2.Bsrc)
            B.x = permute(handles.D2.Bsrc.z(rx,ry,rz), [3 1 2]);
            B.y = permute(handles.D2.Bsrc.x(rx,ry,rz), [3 1 2]);
            B.z = permute(handles.D2.Bsrc.y(rx,ry,rz), [3 1 2]);
            handles.D2.Bwrk = B;
        end
    case sf_types_proj.YZ
        [rx, ry, rz] = l_get_trim(handles);
        B.x = permute(handles.Bsrc.z(rx,ry,rz), [3 2 1]);
        B.y = permute(handles.Bsrc.y(rx,ry,rz), [3 2 1]);
        B.z = permute(handles.Bsrc.x(rx,ry,rz), [3 2 1]);
        handles.Bwrk = B;
        if ~isempty(handles.D2.Bsrc)
            B.x = permute(handles.D2.Bsrc.z(rx,ry,rz), [3 2 1]);
            B.y = permute(handles.D2.Bsrc.y(rx,ry,rz), [3 2 1]);
            B.z = permute(handles.D2.Bsrc.x(rx,ry,rz), [3 2 1]);
            handles.D2.Bwrk = B;
        end
end

if handles.dim_mode == 3
    handles.szWrk = size(handles.Bwrk.x);
else
    handles.szWrk = size(handles.Bwrk);
end

sz = handles.szWrk;
bounds.x = 1:sz(1);
bounds.y = 1:sz(2);
bounds.z = 1:sz(3);
handles = sf_create_metrics(handles, bounds);

guidata(gcf, handles);

if upd
    sf_update(handles);
end

end

function [rx, ry, rz] = l_get_trim(handles)

rz = 1:str2double(get(handles.edit_Z_max, 'String'));
if ~isempty(handles.trim)
    rx = handles.trim.xrange(1):handles.trim.xrange(2);
    ry = handles.trim.yrange(1):handles.trim.yrange(2);
else
    rx = 1:handles.sizes(1);
    ry = 2:handles.sizes(1);
end

end
