// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcGetField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcGetField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD (__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);
typedef DWORD (__cdecl *PROTO_physGetMarkupField)(REALTYPE__ *Bx, REALTYPE__ *By, REALTYPE__ *Bz);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    int N[2];
    FARPROC fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(N, NULL, NULL);
    
    mwSize M[2]; M[0] = N[0]; M[1] = N[1];
    plhs[0] = mxCreateNumericArray(2, M, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *Bx = mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, M, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *By = mxGetPr(plhs[1]);
    plhs[2] = mxCreateNumericArray(2, M, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *Bz = mxGetPr(plhs[2]);

    fp = GetProcAddress(hHSLib, TEXT("physGetMarkupField"));
    PROTO_physGetMarkupField pgstcalcmap = (PROTO_physGetMarkupField)fp;
    (pgstcalcmap)(Bx, By, Bz);
}

