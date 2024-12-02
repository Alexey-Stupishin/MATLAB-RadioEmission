function [x, y] = sf_cursor_to_coord(handles, currPoint)

sza = get(handles.axes1, 'Position');
szd = size(handles.B);

coef = asmScaleRects(sza(3:4), szd(1:2));

x = 0;
y = 0; 

end
