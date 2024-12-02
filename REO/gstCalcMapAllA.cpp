// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcMapAllA.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcMapAllA.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef void (__cdecl *PROTO_setAtmosphere)(int n, REALTYPE__ *_H, REALTYPE__ *_T, REALTYPE__ *_N);

typedef DWORD (__cdecl *PROTO_gstcGetVisParams)(int *_M, double *visstep, double *base);
typedef DWORD (__cdecl *PROTO_gstcGetScanLimits)(REALTYPE__ *limits, int *poslimits);

typedef DWORD (__cdecl *PROTO_gstCalculateMapAll)(REALTYPE__ f, int ns4calc, int *s4calc, int nLayers, REALTYPE__ *pTauL /* nLayers */,
													 int *Mask,
													 int mode, int nBeam, REALTYPE__ *c, REALTYPE__ *b,
												     int nBeamPosOrd, int nBeamPosExt,
													 // out:
													 int *depthOrd, REALTYPE__ *pFOrd /* full intensity */, REALTYPE__ *pTauOrd /* full tau */,  /* nv*nv */ 
													 REALTYPE__ *pHLOrd, REALTYPE__ *pFLOrd /* intensity */, int *psLOrd,  /* nv*nv*nLayers */ 
													 int *depthExt, REALTYPE__ *pFExt /* full intensity */, REALTYPE__ *pTauExt /* full tau */,  /* nv*nv */ 
													 REALTYPE__ *pHLExt, REALTYPE__ *pFLExt /* intensity */, int *psLExt,  /* nv*nv*nLayers */ 
													 REALTYPE__ *pScanOrd, REALTYPE__ *pScanExt, int *pScanLim,
                                                     DWORD *pRC,
	                                                 DWORD *pTimes, int *pQuanc82Cnt, int *pLapl90Cnt, int *pLaplasCnt);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    // --- input ---
    int La = (int)mxGetNumberOfElements(prhs[c]);
    REALTYPE__ *Ha = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    REALTYPE__ *Ta = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    REALTYPE__ *Na = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == La
    // assert(all length are equal to La)

    FARPROC fp;
    fp = GetProcAddress(hHSLib, TEXT("physSetAtmosphere"));
    PROTO_setAtmosphere patm = (PROTO_setAtmosphere)fp;
    (patm)(La, Ha, Ta, Na);

    int Mout[2];
    fp = GetProcAddress(hHSLib, TEXT("gstcGetVisParams"));
    PROTO_gstcGetVisParams pmsize = (PROTO_gstcGetVisParams)fp;
    (pmsize)(Mout, NULL, NULL);

    int *Mask = NULL;
    int szmask = (int)mxGetNumberOfElements(prhs[c]);
    if (szmask > 0)
        Mask = (int *)mxGetPr((mxArray *)prhs[c++]);
    else
        c++;

    REALTYPE__ f = mxGetScalar(prhs[c++]);

    int s4test[16];
    int ns4test = (int)mxGetNumberOfElements(prhs[c]);
    REALTYPE__ *ds4test = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == ns4test
    for (s = 0; s < ns4test; s++)
        s4test[s] = (int)ds4test[s];

    int nLayers = (int)mxGetNumberOfElements(prhs[c]);
    REALTYPE__ *pTauL = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nLayers

    int needScans = 0;
    int mode = 3;
    int nBeam = 0;
    REALTYPE__ *ca = NULL;
    REALTYPE__ *ba = NULL;
    int posOrd = -1;
    int posExt = -1;
    int scansize = Mout[1];
    int limits[2];
    int *plimits = NULL;

    if (nrhs > c)
    {
        needScans = (int)mxGetScalar(prhs[c++]);
    }

    if (nrhs > c)
    {
        mode = (int)mxGetScalar(prhs[c++]);
        if (nrhs > c+2)
        {
            nBeam = (int)mxGetNumberOfElements(prhs[c]); // assert(mode != 4 && nBeam > 1)
            ca = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nBeam
            ba = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nBeam

            if (nrhs > c+1)
            {
                posOrd = (int)mxGetScalar(prhs[c++]);
                posExt = (int)mxGetScalar(prhs[c++]);

                if (nrhs > c)
                {
                    int nlim = (int)mxGetNumberOfElements(prhs[c]);
                    if (nlim >= 2)
                    {
                        REALTYPE__ *dlim = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == 2
                        fp = GetProcAddress(hHSLib, TEXT("gstcGetScanLimits"));
                        PROTO_gstcGetScanLimits pmlim = (PROTO_gstcGetScanLimits)fp;
                        (pmlim)(dlim, limits);
                        plimits = limits;
                        scansize = limits[1] - limits[0] + 1;
                    }
                }
            }
        }
    }

    // --- output ---
    mwSize sz3[3]; sz3[0] = Mout[0]; sz3[1] = Mout[1]; sz3[2] = nLayers;

    c = 0;
    plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *depthOrd = (int *)mxGetPr(plhs[c++]);
    plhs[c] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pFOrd = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pTauOrd = mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pHLOrd = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pFLOrd = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateNumericArray(3, sz3, mxINT32_CLASS, mxREAL);
    int *psLOrd = (int *)mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *depthExt = (int *)mxGetPr(plhs[c++]);
    plhs[c] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pFExt = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pTauExt = mxGetPr(plhs[c++]);

    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pHLExt = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pFLExt = mxGetPr(plhs[c++]);
    plhs[c] = mxCreateNumericArray(3, sz3, mxINT32_CLASS, mxREAL);
    int *psLExt = (int *)mxGetPr(plhs[c++]);

    REALTYPE__ *pScanOrd = NULL;
    if (nlhs > c && needScans)
    {
        plhs[c] = mxCreateDoubleMatrix(1, scansize, mxREAL);
        pScanOrd = mxGetPr(plhs[c++]);
    }
    else
        plhs[c++] = mxCreateDoubleMatrix(0, 0, mxREAL);

    REALTYPE__ *pScanExt = NULL;
    if (nlhs > c && needScans)
    {
        plhs[c] = mxCreateDoubleMatrix(1, scansize, mxREAL);
        pScanExt = mxGetPr(plhs[c++]);
    }
    else
        plhs[c++] = mxCreateDoubleMatrix(0, 0, mxREAL);

    DWORD *pnRC = NULL;
    if (nlhs > c)
    {
        plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pnRC = (DWORD *)mxGetPr(plhs[c++]);
    }

    DWORD *pTimes = NULL;
    if (nlhs > c)
    {
        plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pTimes = (DWORD *)mxGetPr(plhs[c++]);
    }

    int *pQuanc82Cnt = NULL;
    if (nlhs > c)
    {
        plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pQuanc82Cnt = (int *)mxGetPr(plhs[c++]);
    }

    int *pLaplas90Cnt = NULL;
    if (nlhs > c)
    {
        plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pLaplas90Cnt = (int *)mxGetPr(plhs[c++]);
    }

    int *pLaplasCnt = NULL;
    if (nlhs > c)
    {
        plhs[c] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pLaplasCnt = (int *)mxGetPr(plhs[c++]);
    }

    fp = GetProcAddress(hHSLib, TEXT("gstcCalculateMapAll"));
    PROTO_gstCalculateMapAll pgstcalcmap = (PROTO_gstCalculateMapAll)fp;

    MEMORYSTATUSEX mem;
    mem.dwLength = sizeof(mem);
    GlobalMemoryStatusEx(&mem);

    DWORD RC = (pgstcalcmap)(f, ns4test, s4test, nLayers, pTauL, Mask,
        mode, nBeam, ca, ba,
		posOrd, posExt,
        depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd,
        depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt,
        pScanOrd, pScanExt, plimits,
        pnRC,
        pTimes, pQuanc82Cnt, pLaplas90Cnt, pLaplasCnt);

    GlobalMemoryStatusEx(&mem);
}

