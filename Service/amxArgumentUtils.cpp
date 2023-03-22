#include <Windows.h>
#include "mex.h"

//------------------------------------------------------------------ 17-Jan-2012
double* amxGetDoubleArray(int nrhs, const mxArray *prhs[], int idx)
{
    if (idx >= nrhs)
        return NULL;
    return (double *)mxGetPr((mxArray *)prhs[idx]);
}

//------------------------------------------------------------------ 17-Jan-2012
int* amxGetIntArray(int nrhs, const mxArray *prhs[], int idx)
{
    if (idx >= nrhs)
        return NULL;
    double *v = mxGetPr((mxArray *)prhs[idx]);
    int N = (int)mxGetNumberOfElements(prhs[idx]);

    int *I = new int[N];

    for (int i = 0; i < N; i++)
        I[i] = v[i];

    return I;
}

//------------------------------------------------------------------ 17-Jan-2012
UINT64* amxGetUINT64Array(int nrhs, const mxArray *prhs[], int idx)
{
    if (idx >= nrhs)
        return NULL;

    double *v = mxGetPr((mxArray *)prhs[idx]);
    int N = (int)mxGetNumberOfElements(prhs[idx]);

    UINT64 *I = new UINT64[N];

    for (int i = 1; i < N; i++)
        I[i] = v[i];

    return I;
}

//------------------------------------------------------------------ 17-Jan-2012
double amxGetDoubleScalar(int nrhs, const mxArray *prhs[], int idx, double deflt)
{
    if (idx >= nrhs)
        return deflt;

    return (double)mxGetScalar(prhs[idx]);
}

//------------------------------------------------------------------ 17-Jan-2012
int amxGetIntScalar(int nrhs, const mxArray *prhs[], int idx, int deflt)
{
    if (idx >= nrhs)
        return deflt;

    return (int)mxGetScalar(prhs[idx]);
}

//------------------------------------------------------------------ 17-Jan-2012
UINT64 amxGetUINT64Scalar(int nrhs, const mxArray *prhs[], int idx, UINT64 deflt)
{
    if (idx >= nrhs)
        return deflt;

    return (UINT64)mxGetScalar(prhs[idx]);
}

//------------------------------------------------------------------
double *amxCreateDoubleArray(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny)
{
    if (idx >= nlhs)
        return NULL;
    plhs[idx] = mxCreateDoubleMatrix(nx, ny, mxREAL);
    return mxGetPr(plhs[idx]);
}

//------------------------------------------------------------------
int *amxCreateIntArray(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny)
{
    if (idx >= nlhs)
        return NULL;
    plhs[idx] = mxCreateNumericMatrix(nx, ny, mxINT32_CLASS, mxREAL);
    return (int *)mxGetPr(plhs[idx]);
}

//------------------------------------------------------------------
UINT64 *amxCreateUINT64Array(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny)
{
    if (idx >= nlhs)
        return NULL;
    plhs[idx] = mxCreateNumericMatrix(nx, ny, mxUINT64_CLASS, mxREAL);
    return (UINT64 *)mxGetPr(plhs[idx]);
}
