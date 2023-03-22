// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstConvolveMap.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstConvolveMap.cpp -outdir s:\Projects\Matlab\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD (__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);
typedef DWORD (__cdecl *PROTO_gstcGetScanLimits)(REALTYPE__ *limits, int *poslimits);
typedef DWORD (__cdecl *PROTO_gstcConvolve)(REALTYPE__ *map, REALTYPE__ f, REALTYPE__ *scan, int mode,
                           int nBeam, REALTYPE__ *c, REALTYPE__ *b, int *pScanPosLim);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    // --- input ---
    int Mout[2];
    FARPROC fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(Mout, NULL, NULL);

    REALTYPE__ *map = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]);
    REALTYPE__ f = mxGetScalar(prhs[c++]);

    int mode = 3;
    int nBeam = 0;
    REALTYPE__ *ca = NULL;
    REALTYPE__ *ba = NULL;
    int scansize = Mout[1];
    int limits[2];
    int *plimits = NULL;
    REALTYPE__ *dlim = NULL;

    if (nrhs > c)
    {
        mode = (int)mxGetScalar(prhs[c++]);
        if (nrhs > c+1)
        {
            nBeam = (int)mxGetNumberOfElements(prhs[c]); // assert(mode != 4 && nBeam > 1)
            ca = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nBeam
            ba = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nBeam

            if (nrhs > c)
            {
                int nlim = (int)mxGetNumberOfElements(prhs[c]);
                if (nlim == 2)
                {
                    dlim = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == 2
                    fp = GetProcAddress(hHSLib, TEXT("gstcGetScanLimits"));
                    PROTO_gstcGetScanLimits pmlim = (PROTO_gstcGetScanLimits)fp;
                    (pmlim)(dlim, limits);
                    plimits = limits;
                    scansize = limits[1] - limits[0] + 1;
                }
            }
        }
    }

    // --- output ---
    REALTYPE__ *scan;
    plhs[0] = mxCreateDoubleMatrix(1, scansize, mxREAL);
    scan = mxGetPr(plhs[0]);
    if (nlhs > 1)
    {
        if (!dlim)
            plhs[1] = mxCreateDoubleMatrix(0, 0, mxREAL);
        else
        {
            plhs[1] = mxCreateDoubleMatrix(1, 2, mxREAL);
            REALTYPE__ *outlim = mxGetPr(plhs[1]);
            outlim[0] = dlim[0];
            outlim[1] = dlim[1];
        }
    }

    fp = GetProcAddress(hHSLib, TEXT("gstcConvolve"));
    PROTO_gstcConvolve pconv = (PROTO_gstcConvolve)fp;
    DWORD RC = (pconv)(map, f, scan, mode, nBeam, ca, ba, plimits);

}

