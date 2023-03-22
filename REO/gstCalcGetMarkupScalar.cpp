// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstCalcGetMarkupScalar.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstCalcGetMarkupScalar.cpp -outdir s:\Projects\Matlab\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD (__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);
typedef DWORD (__cdecl *PROTO_physGetMarkupScalar)(REALTYPE__ *source, REALTYPE__ *markuped, int *mask);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    REALTYPE__ *source = (REALTYPE__ *)mxGetPr((mxArray *)prhs[1]);

    int N[2];
    FARPROC fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(N, NULL, NULL);
    
    mwSize M[2]; M[0] = N[0]; M[1] = N[1];
    plhs[0] = mxCreateNumericArray(2, M, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *markuped = mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericArray(2, M, mxINT32_CLASS, mxREAL);
    int *mask = (int *)mxGetPr(plhs[1]);

    fp = GetProcAddress(hHSLib, TEXT("physGetMarkupScalar"));
    PROTO_physGetMarkupScalar pgstcalcmap = (PROTO_physGetMarkupScalar)fp;
    (pgstcalcmap)(source, markuped, mask);
}

