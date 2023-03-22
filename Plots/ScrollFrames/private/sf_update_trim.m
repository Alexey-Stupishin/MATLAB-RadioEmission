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
    CurrentPoint = get(handles.axes1, 'CurrentPoint');
    xy = CurrentPoint(1, 1:2);
    if isempty(handles.trimdata.LT)
        handles.trimdata.LT = round(xy);
    else
        handles.trimdata.RB = round(xy);
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
        handles.trim.xrange = [handles.trimdata.RB(2) handles.trimdata.LT(2)];
        handles.trim.yrange = [handles.trimdata.LT(1) handles.trimdata.RB(1)];
        menu = sf_types_FOV.Trim;
    end
end
set(handles.popupmenu_trim, 'Value', menu);

guidata(gcbf, handles);
sf_update(handles);

end
