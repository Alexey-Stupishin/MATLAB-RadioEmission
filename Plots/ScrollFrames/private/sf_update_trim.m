function sf_update_trim(handles, hObject)

global sf_types_FOV

menu = sf_types_FOV.Full_FOV;
if ~exist('hObject', 'var') || ~ishandle(hObject)
    handles.trimdata.LT = [];
    handles.trimdata.RB = [];
    handles.trim = [];
else
    if getappdata(handles.axes1, 'trim') || getappdata(handles.axes1, 'el') ~= 90
        return
    end
    CurrentPoint = floor(get(handles.axes1, 'CurrentPoint') + 0.5);
    xy = CurrentPoint(1, 1:2);
    if isempty(handles.trimdata.LT)
        handles.trimdata.LT = xy + 1 + handles.bound_shift(1:2);
    else
        handles.trimdata.RB = xy + 1 + handles.bound_shift(1:2);
        if handles.trimdata.LT(1) > handles.trimdata.RB(1)
            t = handles.trimdata.LT(1);
            handles.trimdata.LT(1) = handles.trimdata.RB(1);
            handles.trimdata.RB(1) = t;
        end
        if handles.trimdata.RB(2) > handles.trimdata.LT(2)
            t = handles.trimdata.LT(2);
            handles.trimdata.LT(2) = handles.trimdata.RB(2);
            handles.trimdata.RB(2) = t;
        end
        handles.trim.xrange = [handles.trimdata.RB(2) handles.trimdata.LT(2)]; % vert
        handles.trim.yrange = [handles.trimdata.LT(1) handles.trimdata.RB(1)]; % horz
        handles.trim.offset = [handles.trimdata.RB(2) handles.trimdata.LT(1)] - 1;
        menu = sf_types_FOV.Trim;
        
        disp(['trim ' num2str(handles.trim.xrange(1)) ':' num2str(handles.trim.xrange(2)) ', ' num2str(handles.trim.yrange(1)) ':' num2str(handles.trim.yrange(2))])
        
    end
end
set(handles.popupmenu_trim, 'Value', menu);

guidata(gcbf, handles);
sf_update(handles);

end
