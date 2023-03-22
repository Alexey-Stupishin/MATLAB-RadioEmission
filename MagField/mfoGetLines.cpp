// MEX wrapper
//
// mex -v -largeArrayDims -Is:\Projects\Matlab\Service s:\Projects\Matlab\MagField\mfoGetLines.cpp s:\Projects\Matlab\Service\amxArgumentUtils.cpp -outdir s:\Projects\Matlab\MagField
// mex -v -g -largeArrayDims -Is:\Projects\Matlab\Service s:\Projects\Matlab\MagField\mfoGetLines.cpp s:\Projects\Matlab\Service\amxArgumentUtils.cpp -outdir s:\Projects\Matlab\MagField
//

#include <Windows.h>
#include "mex.h"
#include "amxArgumentUtils.h"

typedef DWORD (__cdecl *PROTO_mfoGetLines) (int *N, double *Bx, double *By, double *Bz,
    DWORD _cond, double chromoLevel,
    double  *_seeds, int _Nseeds,
    int nProc,
    double step, double tolerance, double boundAchieve,
    int *_nLines, int *_nPassed,
    int *_voxelStatus, double *_physLength, double *_avField,
    int *_linesLength, int *_codes,
    int *_startIdx, int *_endIdx, int *_apexIdx,
    UINT64 _maxCoordLength, UINT64 *_totalLength, double *_coords, UINT64 *_linesStart, int *_linesIndex, int *seedIdx);

//------------------------------------------------------------------
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    int idx = 1;
    int *N = (int *)amxGetIntArray(nrhs, prhs, idx++); //[3]
    double *Bx = amxGetDoubleArray(nrhs, prhs, idx++); //[N*N*N]
    double *By = amxGetDoubleArray(nrhs, prhs, idx++); //[N*N*N]
    double *Bz = amxGetDoubleArray(nrhs, prhs, idx++); //[N*N*N]

    int Nseeds = amxGetIntScalar(nrhs, prhs, idx++, 0);
    double *seeds = amxGetDoubleArray(nrhs, prhs, idx++); //[3*N]

    UINT64 maxCoordLength = amxGetUINT64Scalar(nrhs, prhs, idx++, 0);

    double chromoLevel = amxGetDoubleScalar(nrhs, prhs, idx++, 0);
    DWORD conditions = (DWORD)amxGetIntScalar(nrhs, prhs, idx++, 0);

    int nProc = amxGetIntScalar(nrhs, prhs, idx++, 0);
    double step = amxGetDoubleScalar(nrhs, prhs, idx++, 1);
    double tolerance = amxGetDoubleScalar(nrhs, prhs, idx++, 1e-3);
    double boundAchieve = amxGetDoubleScalar(nrhs, prhs, idx++, 1e-3);

    int NF = N[0]*N[1]*N[2];
    int nL = (!seeds || Nseeds <= 0 ? NF : Nseeds);

    idx = 0;
    DWORD *pnRC = (DWORD *)amxCreateIntArray(nlhs, plhs, idx++, 1, 1);
    double *physLength = amxCreateDoubleArray(nlhs, plhs, idx++, 1, nL);
    double *avField = amxCreateDoubleArray(nlhs, plhs, idx++, 1, nL);
    int *startIdx = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *endIdx = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *seedIdx = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *apexIdx = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    UINT64 *totalLength = amxCreateUINT64Array(nlhs, plhs, idx++, 1, 1);
    double *coords = amxCreateDoubleArray(nlhs, plhs, idx++, 1, 4*maxCoordLength);
    UINT64 *linesStart = amxCreateUINT64Array(nlhs, plhs, idx++, 1, nL);
    int *linesLength = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *linesIndex = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *status = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *codes = amxCreateIntArray(nlhs, plhs, idx++, 1, nL);
    int *nLines = amxCreateIntArray(nlhs, plhs, idx++, 1, 1);
    int *nPassed = amxCreateIntArray(nlhs, plhs, idx++, 1, 1);

    FARPROC fpline = GetProcAddress(hHSLib, (LPCSTR)TEXT("mfoGetLines"));
    DWORD rc = ((PROTO_mfoGetLines)fpline)(N, Bx, By, Bz,
        conditions, chromoLevel,
        seeds, Nseeds,
        nProc, step, tolerance, boundAchieve,
        nLines, nPassed,
        status, physLength, avField,
        linesLength, codes,
        startIdx, endIdx, apexIdx,
        maxCoordLength, totalLength, coords, linesStart, linesIndex, seedIdx);

    if (pnRC)
        *pnRC = rc;
}
