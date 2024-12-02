function sf_set_allowed_types(handles, sWhat)

global sf_types_what sf_types_what_string sf_types_what_quiver sf_types_set_string

idx = get(handles.popupmenu_dataset, 'Value');
ds = sf_types_set_string{idx};

sf_types_what_quiver = {};
k = 1;
s = 'B';                  sf_types_what.(s) = k;  sf_types_what_string{k} = s; k = k + 1; 
if handles.dim_mode == 3
    sf_types_what_quiver = [sf_types_what_quiver {{'Bx', 'By'}}]; 
else
    sf_types_what_quiver = [sf_types_what_quiver 0]; 
end

if handles.dim_mode == 3
    s = 'Bx';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'By', 'Bz'}}]; k = k + 1; 
    s = 'By';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Bz', 'Bx'}}]; k = k + 1; 
    s = 'Bz';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Bx', 'By'}}]; k = k + 1; 
    s = 'B_transv';       sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
    s = 'azimuth';        sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
    s = 'inclination';    sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
    s = 'J';              sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Jx', 'Jy'}}]; k = k + 1; 
    s = 'Jx';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Jy', 'Jz'}}]; k = k + 1; 
    s = 'Jy';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Jz', 'Jx'}}]; k = k + 1; 
    s = 'Jz';             sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver {{'Jx', 'Jy'}}]; k = k + 1; 
    s = 'JxB_angle';      sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
    s = 'divB';           sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
%    if strcmp(ds, 'delta')
        s = 'Dangle';         sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
        s = 'Dresidual';      sf_types_what.(s) = k;  sf_types_what_string{k} = s; sf_types_what_quiver = [sf_types_what_quiver 0]; k = k + 1;
%    end
end

set(handles.popupmenu_what, 'String', sf_types_what_string);

idx = find(strcmp(sWhat, sf_types_what_string));
if isempty(idx)
    idx = 1;
end

set(handles.popupmenu_what, 'Value', idx);
    
end
