// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\utilsLoadLibrary.cpp -outdir s:\Projects\Conveyor\MATLAB
// mex -v -g -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\utilsLoadLibrary.cpp -outdir s:\Projects\Conveyor\MATLAB
//

#include <Windows.h>

#include "mex.h"

//-------------------------------------------------------------------------------------
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    BOOL b = FALSE;
    char *libname = mxArrayToString(prhs[0]);
    if (nrhs > 1)
    {
        char *path = mxArrayToString(prhs[1]);
        b = SetDllDirectory(path);
    }

    HINSTANCE hHSLib = LoadLibrary(libname);
    DWORD rc = GetLastError();

    //if (nlhs > 1)
    //    SetDllDirectory(NULL);

    int ihHSLib = (int)hHSLib;

    plhs[0] = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
    UINT64 *objptr = (UINT64 *)mxGetPr(plhs[0]);
    *objptr = (UINT64)hHSLib;
}
