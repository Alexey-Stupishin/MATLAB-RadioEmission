// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstCalcCallAKGR.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstCalcCallAKGR.cpp -outdir s:\Projects\Matlab\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

//typedef int (__cdecl *PROTO_akCalculateMap)(short n, double *params, double *output);
typedef int (__cdecl *PROTO_akCalculateMap)(int argc, void **argv);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    short Nz = (short)mxGetScalar(prhs[1]);
    double *params = (double *)mxGetPr((mxArray *)prhs[2]); // 30xNz
    int Nf = (int)(params[18]);

    plhs[0] = mxCreateDoubleMatrix(7, Nf, mxREAL);
    double *RL = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL); // rc
    double *pnRC = mxGetPr(plhs[1]);

    void *argv[3];
    argv[0] = &Nz;
    argv[1] = params;
    argv[2] = RL;

    int rc = -999;

    FARPROC fp = GetProcAddress(hHSLib, TEXT("GET_MW"));
    DWORD rcle = GetLastError();
    if (fp)
    {
        PROTO_akCalculateMap pakcalcmap = (PROTO_akCalculateMap)fp;
        rc = (pakcalcmap)(3, argv);
    }

    *pnRC = (double)rc;
}