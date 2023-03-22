// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\gstSetPreferenceInt.cpp -outdir s:\Projects\Conveyor\MATLAB
// mex -v -g -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\gstSetPreferenceInt.cpp -outdir s:\Projects\Conveyor\MATLAB
//

#include <Windows.h>

#include "mex.h"

typedef int (__cdecl *PROTO_setInt) (char *query, int value);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);
    char *prefname = mxArrayToString(prhs[1]);
    int value = (int)mxGetScalar(prhs[2]);

    FARPROC fp = GetProcAddress(hHSLib, TEXT("utilSetInt"));
    PROTO_setInt psetInt = (PROTO_setInt)fp;

    (psetInt)(prefname, value);
}
