function [data, q1, q2] = sf_get_data(handles, what)

global sf_types_set_string

dataset = get(handles.popupmenu_dataset, 'Value');
if strcmp(sf_types_set_string{dataset}, 'data_1')
    [data, q1, q2] = l_get(handles, what);
elseif strcmp(sf_types_set_string{dataset}, 'data_2')
    [data, q1, q2] = l_get(handles.D2, what);
else
    [data, q1, q2] = l_get(handles, what);
    [data2, q12, q22] = l_get(handles.D2, what);
    data = data - data2;
    q1 = q1 - q12;
    q2 = q2 - q22;
end

end

%--------------------------------------------------------------------------
function [data, q1, q2] = l_get(structdata, what)

global sf_types_what_string sf_types_what_quiver

type = sf_types_what_string{what};
data = structdata.(type);
q1 = [];
q2 = [];

quiv = sf_types_what_quiver{what};
if iscell(quiv)
    q1 = structdata.(quiv{1});
    q2 = structdata.(quiv{2});
end

end
