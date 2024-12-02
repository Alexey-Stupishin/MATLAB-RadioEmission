function sf_get_point_value(handles, point)

global sf_types_FOV

if ~isempty(point)
    xy = floor([point(2) point(1)] + 0.5);
    
    disp(['sel ' num2str(xy(2)) ' ' num2str(xy(1))])
    
    xy = xy + 1;
    
    if ~isempty(handles.trim) && get(handles.popupmenu_trim, 'Value') == sf_types_FOV.Trim
        xy = xy + handles.trim.offset;
    else
        xy = xy + handles.bound_shift(1:2);
    end
    
    handles.select.xy = xy; % + handles.bound_shift(1:2);
else
    handles.select = [];
end

guidata(gcbf, handles);
sf_update(handles);

end
