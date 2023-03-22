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

typedef  int (__cdecl *PROTO_gstcCalculateLineFromLOS)(int L, REALTYPE__ *H /* L */, REALTYPE__ *B, REALTYPE__ *cost, REALTYPE__ *_T, REALTYPE__ *_N,
                                                    int nf, REALTYPE__ *pf, int ns4calc, int *s4calc,
                                                    int nLayers, REALTYPE__ *pTauL /* nLayers */,
                                                    int *depth /* 2*nf */, REALTYPE__ *pF /* full intensity, 2*nf */, REALTYPE__ *pTau /* full tau, 2*nf */,
                                                    REALTYPE__ *pHL /* heights, 2*nLayers*nf */, REALTYPE__ *pFL /* intensity, 2*nLayers*nf */, int *psL /* 2*nLayers*nf */, DWORD *pRC);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // hLib, L, H, B, c, La, Ha, Na, Ta, f, ns4calc, s4calc, nLayers, pTauL

    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    int L = (int)mxGetNumberOfElements(prhs[1]);
    double *H = (double *)mxGetPr((mxArray *)prhs[1]); // length == L
    double *B = (double *)mxGetPr((mxArray *)prhs[2]); // length == L
    double *c = (double *)mxGetPr((mxArray *)prhs[3]); // length == L
    double *Ta = (double *)mxGetPr((mxArray *)prhs[4]); // length == L
    double *Na = (double *)mxGetPr((mxArray *)prhs[5]); // length == L

    int nf = (int)mxGetNumberOfElements(prhs[6]);
    double *pf = (double *)mxGetPr((mxArray *)prhs[6]); // length == nf

    int ns4calc = (int)mxGetNumberOfElements(prhs[7]);
    int i;
    double *ds = (double *)mxGetPr((mxArray *)prhs[7]); // length == ns4calc
    int *s4calc = new int[ns4calc];
    for (i = 0; i < ns4calc; i++)
        s4calc[i] = (int)ds[i];

    int nLayers = (int)mxGetNumberOfElements(prhs[8]);
    double *pTauL = (double *)mxGetPr((mxArray *)prhs[8]); // length == nLayers

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
    (pfunc)(L, H, B, c, Ta, Na, 
            nf, pf, ns4calc, s4calc,
            nLayers, pTauL,
            depth, pF, pTau, 
            pHL, pFL, psL,
            &rc);
    *pnRC = rc;

    delete [] s4calc;
}

