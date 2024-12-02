function handles = sf_create_metrics(handles, bounds)

if handles.dim_mode == 3
    sz = size(handles.Bwrk.x);
else
    sz = size(handles.Bwrk);
end
if ~exist('bounds', 'var') || isempty(bounds)
    bounds.x = 1:sz(1);
    bounds.y = 1:sz(2);
    if handles.dim_mode == 3
        bounds.z = 1:sz(3);
    end
end

handles = sf_create_metrics_core(handles, handles.Bwrk, handles.D2.Bwrk, bounds);

end
