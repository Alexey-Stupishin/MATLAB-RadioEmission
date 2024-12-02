function handles = sf_create_metrics_core(handles, B1, B2, bounds)

if handles.dim_mode == 1
    handles.B = B1(bounds.x, bounds.y, bounds.z);
    if handles.comp_mode == 2
        handles.D2.B = B2(bounds.x, bounds.y, bounds.z);
    end
    return
end

B = mfoTrimField(fpuField2XYZ(B1), bounds.x, bounds.y, bounds.z);
handles.B = fpuFieldVal(B);
handles.B3 = B;
handles = mfmCalcMetrics(B, handles);

if ~isempty(B2)
    B = mfoTrimField(fpuField2XYZ(B2), bounds.x, bounds.y, bounds.z);
    handles.D2.B = fpuFieldVal(B);
    handles.D2.B3 = B;
    handles.D2 = mfmCalcMetrics(B, handles.D2);

    [handles.M_angle, handles.M_res] = mfmCalcMetricDiff(handles.B3, handles.D2.B3);
end
