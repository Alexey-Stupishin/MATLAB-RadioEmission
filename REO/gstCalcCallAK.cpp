// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstCalcCallAK.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstCalcCallAK.cpp -outdir s:\Projects\Matlab\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

typedef double (__cdecl *PROTO_akCalculateMap)(int argc, void *argv[]);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    void *argv[6];
    argv[0] = (void *)mxGetPr((mxArray *)prhs[1]);
    argv[1] = (void *)mxGetPr((mxArray *)prhs[2]); // 30xNz
    argv[2] = NULL;
    argv[3] = NULL;
    argv[4] = NULL;
    
    int Nf = (int)(((double *)argv[1])[18]);
    plhs[0] = mxCreateDoubleMatrix(7, Nf, mxREAL);
    argv[5] = (void *)mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL); // rc
    double *pnRC = mxGetPr(plhs[1]);

    *pnRC = -999;

    FARPROC fp = GetProcAddress(hHSLib, TEXT("GET_MW"));
    DWORD rcle = GetLastError();
    if (fp)
        *pnRC = ((PROTO_akCalculateMap)fp)(6, argv);
}