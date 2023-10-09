// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstGetLOSField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstGetLOSField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD(__cdecl *PROTO_gstcGetLOSFieldEst)();
typedef DWORD(__cdecl *PROTO_gstcGetLOSField)(int *Mask, int *_depth, REALTYPE__ *_H, REALTYPE__ *_B, REALTYPE__ *_cos);
typedef DWORD(__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    FARPROC fp;
    fp = GetProcAddress(hHSLib, TEXT("gstcGetLOSFieldEst"));
    PROTO_gstcGetLOSFieldEst pest = (PROTO_gstcGetLOSFieldEst)fp;
    DWORD L = (pest)();

    // --- input
    int szmask = (int)mxGetNumberOfElements(prhs[c]);
    int *Mask = (int *)mxGetPr((mxArray *)prhs[c++]);

    int Mout[2];
    fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(Mout, NULL, NULL);
    // assert: M[0]*M[1] == szmask

    // --- output ---
    mwSize sz3[3]; sz3[0] = Mout[0]; sz3[1] = Mout[1]; sz3[2] = L;

    c = 0;
    plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *pDepth = (int *)mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pH = mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pB = mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pcos = mxGetPr(plhs[c++]);

    fp = GetProcAddress(hHSLib, TEXT("gstcGetLOSField"));
    PROTO_gstcGetLOSField p = (PROTO_gstcGetLOSField)fp;
    DWORD RC = (p)(Mask, pDepth, pH, pB, pcos);
}

