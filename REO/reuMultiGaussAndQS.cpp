// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\reuMultiGaussAndQS.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\reuMultiGaussAndQS.cpp -outdir s:\Projects\Matlab\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

__declspec(dllexport) int aduMultiGaussAndQS(int _NData, double *_points, double *_fluxes, double _R, double _step, double _freq
    , int Nnew, double *newp, int Nold, double *oldp, double *parqs
    , double *apprResult, double *solResult
    , MGQSFuncData::Mode, CagpQuietSun::Disc);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    // --- input ---
    int NData = (int)mxGetNumberOfElements(prhs[c]);
    double *points = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == NData
    double *fluxes = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == NData

    double R = mxGetScalar(prhs[c++]);
    double step = mxGetScalar(prhs[c++]);
    double freq = mxGetScalar(prhs[c++]);

    int New = ((int)mxGetNumberOfElements(prhs[c]));

    //-----------------------------------------------------------------------

    int szfield = Mout[0]*Mout[1];
    int szmask = (int)mxGetNumberOfElements(prhs[c]);
    int *Mask = new int[szfield];
    if (szmask == szfield)
    {
        REALTYPE__ *dMask = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == Mout[0]*Mout[1]
        for (int k = 0; k < szfield; k++)
            Mask[k] = (int)dMask[k];
    }
    else
    {
        c++;
        for (int k = 0; k < szfield; k++)
            Mask[k] = 1;
    }

    REALTYPE__ f = mxGetScalar(prhs[c++]);

    int s4test[16];
    int ns4test = (int)mxGetNumberOfElements(prhs[c]);
    REALTYPE__ *ds4test = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == ns4test
    for (s = 0; s < ns4test; s++)
        s4test[s] = (int)ds4test[s];

    int nLayers = (int)mxGetNumberOfElements(prhs[c]);
    REALTYPE__ *pTauL = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]); // length == nLayers

    int needFF = (int)mxGetScalar(prhs[c++]);
    int needScans = (int)mxGetScalar(prhs[c++]);

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

    plhs[0] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *depthOrd = (int *)mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pFOrd = mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pTauOrd = mxGetPr(plhs[2]);

    plhs[3] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pHLOrd = mxGetPr(plhs[3]);
    plhs[4] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pFLOrd = mxGetPr(plhs[4]);
    plhs[5] = mxCreateNumericArray(3, sz3, mxINT32_CLASS, mxREAL);
    int *psLOrd = (int *)mxGetPr(plhs[5]);

    plhs[6] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
    int *depthExt = (int *)mxGetPr(plhs[6]);
    plhs[7] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pFExt = mxGetPr(plhs[7]);
    plhs[8] = mxCreateDoubleMatrix(Mout[0], Mout[1], mxREAL);
    REALTYPE__ *pTauExt = mxGetPr(plhs[8]);

    plhs[9] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pHLExt = mxGetPr(plhs[9]);
    plhs[10] = mxCreateNumericArray(3, sz3, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *pFLExt = mxGetPr(plhs[10]);
    plhs[11] = mxCreateNumericArray(3, sz3, mxINT32_CLASS, mxREAL);
    int *psLExt = (int *)mxGetPr(plhs[11]);

    REALTYPE__ *pScanOrd = NULL;
    if (nlhs > 12 && needScans)
    {
        plhs[12] = mxCreateDoubleMatrix(1, scansize, mxREAL);
        pScanOrd = mxGetPr(plhs[12]);
    }
    else
        plhs[12] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pScanExt = NULL;
    if (nlhs > 13 && needScans)
    {
        plhs[13] = mxCreateDoubleMatrix(1, scansize, mxREAL);
        pScanExt = mxGetPr(plhs[13]);
    }
    else
        plhs[13] = mxCreateDoubleMatrix(0, 0, mxREAL);

    int *pdepthFF = NULL;
    if (nlhs > 14 && needFF)
    {
        plhs[14] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
        pdepthFF = (int *)mxGetPr(plhs[14]);
    }
    else
        plhs[14] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pFFF = NULL;
    if (nlhs > 15 && needFF)
    {
        plhs[15] = mxCreateDoubleMatrix(1, 1, mxREAL);
        pFFF = mxGetPr(plhs[15]);
    }
    else
        plhs[15] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pTauFF = NULL;
    if (nlhs > 16 && needFF)
    {
        plhs[16] = mxCreateDoubleMatrix(1, 1, mxREAL);
        pTauFF = mxGetPr(plhs[16]);
    }
    else
        plhs[16] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pHFFL = NULL;
    if (nlhs > 17 && needFF)
    {
        plhs[17] = mxCreateDoubleMatrix(1, nLayers, mxREAL);
        pHFFL = mxGetPr(plhs[17]);
    }
    else
        plhs[17] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pFFFL = NULL;
    if (nlhs > 18 && needFF)
    {
        plhs[18] = mxCreateDoubleMatrix(1, nLayers, mxREAL);
        pFFFL = mxGetPr(plhs[18]);
    }
    else
        plhs[18] = mxCreateDoubleMatrix(0, 0, mxREAL);
    REALTYPE__ *pConvFF = NULL;
    if (nlhs > 19 && needFF && needScans)
    {
        plhs[19] = mxCreateDoubleMatrix(1, scansize, mxREAL);
        pConvFF = mxGetPr(plhs[19]);
    }
    else
        plhs[19] = mxCreateDoubleMatrix(0, 0, mxREAL);

    DWORD *pnRC = NULL;
    if (nlhs > 20)
    {
        plhs[20] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pnRC = (DWORD *)mxGetPr(plhs[20]);
    }

    DWORD *pTimes = NULL;
    if (nlhs > 21)
    {
        plhs[21] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pTimes = (DWORD *)mxGetPr(plhs[21]);
    }

    int *pQuanc82Cnt = NULL;
    if (nlhs > 22)
    {
        plhs[22] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pQuanc82Cnt = (int *)mxGetPr(plhs[22]);
    }

    int *pLaplas90Cnt = NULL;
    if (nlhs > 23)
    {
        plhs[23] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pLaplas90Cnt = (int *)mxGetPr(plhs[23]);
    }

    int *pLaplasCnt = NULL;
    if (nlhs > 24)
    {
        plhs[24] = mxCreateNumericMatrix(Mout[0], Mout[1], mxINT32_CLASS, mxREAL);
        pLaplasCnt = (int *)mxGetPr(plhs[24]);
    }

  //  fp = GetProcAddress(hHSLib, TEXT("gstcCalculateMapAll"));
  //  PROTO_gstCalculateMapAll pgstcalcmap = (PROTO_gstCalculateMapAll)fp;
  //  DWORD RC = (pgstcalcmap)(f, ns4test, s4test, nLayers, pTauL, Mask,
  //      mode, nBeam, ca, ba,
		//posOrd, posExt,
  //      depthOrd, pFOrd, pTauOrd, pHLOrd, pFLOrd, psLOrd,
  //      depthExt, pFExt, pTauExt, pHLExt, pFLExt, psLExt,
  //      pScanOrd, pScanExt, plimits,
  //      pdepthFF, pFFF, pTauFF, pHFFL, pFFFL, pConvFF,
  //      pnRC,
  //      pTimes, pQuanc82Cnt, pLaplas90Cnt, pLaplasCnt);

    delete[] Mask;
}

