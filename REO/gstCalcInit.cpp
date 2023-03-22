// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstCalcInit.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstCalcInit.cpp -outdir s:\Projects\Matlab\REO
//

#include <Windows.h>

#include "mex.h"

typedef UINT64 (__cdecl *PROTO_Init) (char *, char *);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    char *path = NULL;
    if (nrhs > 1)
        path = mxArrayToString(prhs[1]);
    char *addpath = NULL;
    if (nrhs > 2)
        addpath = mxArrayToString(prhs[2]);

    FARPROC fp = GetProcAddress(hHSLib, TEXT("utilInitialize"));
    PROTO_Init pInit = (PROTO_Init)fp;
    (pInit)(path, addpath);
}
