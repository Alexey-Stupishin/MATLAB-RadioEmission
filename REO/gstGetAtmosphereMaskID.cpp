// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstGetAtmosphereMaskID.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstGetAtmosphereMaskID.cpp -outdir s:\Projects\Matlab\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD(__cdecl *PROTO_physGetAtmosphereMaskID)(REALTYPE__ *Heights, int *maskN);
typedef DWORD(__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    REALTYPE__ *H = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]);

    int Mout[2];
    FARPROC fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(Mout, NULL, NULL);

    c = 0;
    plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *maskN = (int *)mxGetPr(plhs[c++]);

    fp = GetProcAddress(hHSLib, TEXT("physGetAtmosphereMaskID"));
    PROTO_physGetAtmosphereMaskID pgstatmmap = (PROTO_physGetAtmosphereMaskID)fp;
    DWORD RC = (pgstatmmap)(H, maskN);
}

