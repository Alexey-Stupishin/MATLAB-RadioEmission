function sf_move(handles, coord, dir)

if ~isempty(handles.select)
    handles.select.xy(coord)  = max(1, min(handles.szWrk(coord), handles.select.xy(coord)  + 1*dir));
    guidata(gcbf, handles);
    sf_update(handles);
end

end
