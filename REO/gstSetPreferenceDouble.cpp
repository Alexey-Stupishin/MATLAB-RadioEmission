// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\gstSetPreferenceDouble.cpp -outdir s:\Projects\Conveyor\MATLAB
// mex -v -g -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\gstSetPreferenceDouble.cpp -outdir s:\Projects\Conveyor\MATLAB
//

#include <Windows.h>

#include "mex.h"

typedef int (__cdecl *PROTO_setDouble) (char *query, double value);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);
    char *prefname = mxArrayToString(prhs[1]);
    double value = mxGetScalar(prhs[2]);

    FARPROC fp = GetProcAddress(hHSLib, TEXT("utilSetDouble"));
    PROTO_setDouble psetDouble = (PROTO_setDouble)fp;

    (psetDouble)(prefname, value);
}
