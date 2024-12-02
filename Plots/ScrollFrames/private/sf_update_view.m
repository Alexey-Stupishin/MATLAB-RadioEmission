function sf_update_view(handles, what, dir)

if strcmp(what, 'TOP')
    set(handles.text_az, 'String', '0');
    set(handles.text_el, 'String', '90');
elseif strcmp(what, 'SIDE')
    set(handles.text_az, 'String', '0');
    set(handles.text_el, 'String', '0');
elseif strcmp(what, 'CAMERA')
    set(handles.text_az, 'String', '-38');
    set(handles.text_el, 'String', '30');
else
    vpage = 15;
    vline = 1;

    if strcmp(what, 'AZ')
        h = handles.text_az;
    else
        h = handles.text_el;
    end

    v = str2double(get(h, 'String'));
    switch dir
        case 'UU'
            v = v + vpage;
        case 'U'
            v = v + vline;
        case 'D'
            v = v - vline;
        case 'DD'
            v = v - vpage;
    end
    set(h, 'String', num2str(v));
end

sf_update(handles);

end
