// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstSetAtmosphere.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstSetAtmosphere.cpp -outdir s:\Projects\Matlab\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef void (__cdecl *PROTO_setAtmosphere)(int n, REALTYPE__ *_H, REALTYPE__ *_T, REALTYPE__ *_D);
typedef void (__cdecl *PROTO_setAtmosphereVar)(int *N, REALTYPE__ *_H, REALTYPE__ *_T, REALTYPE__ *_D);
typedef void (__cdecl *PROTO_resetAtmosphereVar)(int *N, REALTYPE__ *_H, REALTYPE__ *_T, REALTYPE__ *_D);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    int La = 0;
    int *N = NULL;

    mwSize nDim = mxGetNumberOfDimensions(prhs[c]);
    if (nDim == 3)
        N = (int *)mxGetPr((mxArray *)prhs[c++]);
    else
        La = (int)mxGetNumberOfElements(prhs[c]);

    REALTYPE__ *Ha = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    REALTYPE__ *Ta = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    REALTYPE__ *Na = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    // assert(all length are equal to dims)

    FARPROC fp;
    if (nDim == 3)
    {
        bool reset = true;
        if (nrhs > c && mxGetScalar(prhs[c++]) != 0) // 5th parameter is not 0, init
        {
            fp = GetProcAddress(hHSLib, TEXT("physSetAtmosphereVar"));
            PROTO_setAtmosphereVar patm = (PROTO_setAtmosphereVar)fp;
            (patm)(N, Ha, Ta, Na);
        }
        else
        {
            fp = GetProcAddress(hHSLib, TEXT("physResetAtmosphereVar"));
            PROTO_resetAtmosphereVar patm = (PROTO_resetAtmosphereVar)fp;
            (patm)(N, Ha, Ta, Na);
        }
    }
    else
    {
        fp = GetProcAddress(hHSLib, TEXT("physSetAtmosphere"));
        PROTO_setAtmosphere patm = (PROTO_setAtmosphere)fp;
        (patm)(La, Ha, Ta, Na);
    }
}

