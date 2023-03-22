function reoSetDebug(hLib, x, y)

gstSetPreferenceInt(hLib, 'cycloMap.nThreadsInitial', 1);

if exist('x', 'var') && exist('y', 'var')
    gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.i', x);
    gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.j', y);
    gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.GyroLayerProfile', 1);
else
    gstSetPreferenceInt(hLib, 'Debug.AtPoint.ZoneTrace.GyroLayerProfile', 0);
end

end
