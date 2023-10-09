// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstCalcLineByLOS.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstCalcLineByLOS.cpp -outdir s:\Projects\Matlab\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef  int (__cdecl *PROTO_gstcCalculateLineFromLOS)(int L, REALTYPE__ *H /* L */, REALTYPE__ *B, REALTYPE__ *cost, 
                                                    int La, REALTYPE__ *Ha, REALTYPE__ *_T, REALTYPE__ *_N,
                                                    int nf, REALTYPE__ *pf, int ns4calc, int *s4calc,
                                                    int nLayers, REALTYPE__ *pTauL /* nLayers */,
                                                    int *depth /* 2*nf */, REALTYPE__ *pF /* full intensity, 2*nf */, REALTYPE__ *pTau /* full tau, 2*nf */,
                                                    REALTYPE__ *pHL /* heights, 2*nLayers*nf */, REALTYPE__ *pFL /* intensity, 2*nLayers*nf */, int *psL /* 2*nLayers*nf */, DWORD *pRC);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // hLib, L, H, B, c, La, Ha, Na, Ta, f, ns4calc, s4calc, nLayers, pTauL

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    int L = (int)mxGetNumberOfElements(prhs[c]);
    double *H = (double *)mxGetPr((mxArray *)prhs[c++]); // length == L
    double *B = (double *)mxGetPr((mxArray *)prhs[c++]); // length == L
    double *cost = (double *)mxGetPr((mxArray *)prhs[c++]); // length == L
    int La = (int)mxGetNumberOfElements(prhs[c]);
    double *Ha = (double *)mxGetPr((mxArray *)prhs[c++]); // length == La
    double *Ta = (double *)mxGetPr((mxArray *)prhs[c++]); // length == La
    double *Na = (double *)mxGetPr((mxArray *)prhs[c++]); // length == La

    int nf = (int)mxGetNumberOfElements(prhs[c]);
    double *pf = (double *)mxGetPr((mxArray *)prhs[c++]); // length == nf

    int ns4calc = (int)mxGetNumberOfElements(prhs[c]);
    int i;
    double *ds = (double *)mxGetPr((mxArray *)prhs[c++]); // length == ns4calc
    int *s4calc = new int[ns4calc];
    for (i = 0; i < ns4calc; i++)
        s4calc[i] = (int)ds[i];

    int nLayers = (int)mxGetNumberOfElements(prhs[c]);
    double *pTauL = (double *)mxGetPr((mxArray *)prhs[c++]); // length == nLayers

    int szh = 64000;

    mwSize dims[3];
    dims[0] = 2; dims[1] = nLayers; dims[2] = nf;
    plhs[0] = mxCreateNumericMatrix(2, nf, mxINT32_CLASS, mxREAL);
    int *depth = (int *)mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(2, nf, mxREAL);
    double *pF = mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(2, nf, mxREAL);
    double *pTau = mxGetPr(plhs[2]);
    plhs[3] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    double *pHL = mxGetPr(plhs[3]);
    plhs[4] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    double *pFL = mxGetPr(plhs[4]);
    plhs[5] = mxCreateNumericArray(3, dims, mxINT32_CLASS, mxREAL);
    int *psL = (int *)mxGetPr(plhs[5]);

    plhs[6] = mxCreateDoubleMatrix(1, 1, mxREAL); // rc
    double *pnRC = mxGetPr(plhs[6]);
    
    FARPROC fp = GetProcAddress(hHSLib, TEXT("gstcCalculateLineFromLOS"));
    PROTO_gstcCalculateLineFromLOS pfunc = (PROTO_gstcCalculateLineFromLOS)fp;

    DWORD rc;
    (pfunc)(L, H, B, cost, 
            La, Ha, Ta, Na, 
            nf, pf, ns4calc, s4calc,
            nLayers, pTauL,
            depth, pF, pTau, 
            pHL, pFL, psL,
            &rc);
    *pnRC = rc;

    delete [] s4calc;
}

