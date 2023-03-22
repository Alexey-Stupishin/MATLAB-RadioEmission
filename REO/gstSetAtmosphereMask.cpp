// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\REO\gstSetAtmosphereMask.cpp -outdir s:\Projects\Matlab\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\REO\gstSetAtmosphereMask.cpp -outdir s:\Projects\Matlab\REO

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef DWORD(__cdecl *PROTO_physSetAtmosphereMask)(int _nmask, int _maxH, int *_Lmask, REALTYPE__ *_H, REALTYPE__ *_T, REALTYPE__ *_D, int *_masksN, int *_N, int *_mask);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int d, s;

    int c = 0;
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[c++]);

    // _N - mask size (Nx, Ny)
    // _mask - mask itself [Nx * Ny]

    mwSize *__N = (mwSize *)mxGetDimensions(prhs[c]);
    int N[2];
    N[0] = __N[0];
    N[1] = __N[1];
    int *mask = (int *)mxGetPr((mxArray *)prhs[c++]);

    // _nmask - N of mask values
    // _masksN - mask values [nmask]
    int nmask = (int)mxGetNumberOfElements(prhs[c]);
    int *masksN = (int *)mxGetPr((mxArray *)prhs[c++]);

    // _Lmask - length of H,T,D for each mask value [nmask]
    // H,T,D - 2D [maxH(Lmask[imask])*nMask]
    int *NAtm = (int *)mxGetDimensions(prhs[c]);
    int maxH = NAtm[0];
    REALTYPE__ *H = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]);
    REALTYPE__ *T = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]);
    REALTYPE__ *D = (REALTYPE__ *)mxGetPr((mxArray *)prhs[c++]);

    int *Lmask = (int *)mxGetPr((mxArray *)prhs[c++]);

    FARPROC fp = GetProcAddress(hHSLib, TEXT("physSetAtmosphereMask"));
    PROTO_physSetAtmosphereMask pgstatmmap = (PROTO_physSetAtmosphereMask)fp;
    DWORD RC = (pgstatmmap)(nmask, maxH, Lmask, H, T, D, masksN, N, mask);
}

