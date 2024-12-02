// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcSetField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
// mex -v -g -largeArrayDims s:\Projects\Matlab\MatlabUtils\REO\gstCalcSetField.cpp -outdir s:\Projects\Matlab\MatlabUtils\REO
//

#include <Windows.h>

#include "mex.h"
#define _USE_MATH_DEFINES
#include "math.h"

#define REALTYPE__ double

typedef void (__cdecl *PROTO_physSetField)(REALTYPE__ *_fieldX, REALTYPE__ *_fieldY, REALTYPE__ *_fieldZ, int *M, int *_N, 
                                        REALTYPE__ *_vcos, REALTYPE__ *_step, REALTYPE__ *_baseP);
typedef void (__cdecl *PROTO_physSetFieldPlaneMeshgridRect)(REALTYPE__ *visstep, REALTYPE__ posangle, int *nv, REALTYPE__ *minv, BOOL bAutoCalc);

//------------------------------------------------------------------ 17-Jan-2012
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // hLib, La, Ha, N, T, M, N, fieldX, fieldY, fieldZ, vcos, step, baseP, baseV
    // visstep, f, ns4calc, s4calc, maxTau, nLayers, pTauL

    int d, s;

    HINSTANCE hHSLib = (HINSTANCE)*(UINT64 *)mxGetData(prhs[0]);

    REALTYPE__ *dM = mxGetPr((mxArray *)prhs[1]); // length == 3
    int M[3];
    for (d = 0; d < 3; d++)
        M[d] = (int)dM[d];
    REALTYPE__ *dN = mxGetPr((mxArray *)prhs[2]); // length == 3
    int N[3];
    for (d = 0; d < 3; d++)
        N[d] = (int)dN[d];
    REALTYPE__ *fieldX = (REALTYPE__ *)mxGetPr((mxArray *)prhs[3]); // length == M[0]*M[1]*M[2]
    REALTYPE__ *fieldY = (REALTYPE__ *)mxGetPr((mxArray *)prhs[4]); // length == M[0]*M[1]*M[2]
    REALTYPE__ *fieldZ = (REALTYPE__ *)mxGetPr((mxArray *)prhs[5]); // length == M[0]*M[1]*M[2]
    REALTYPE__ *vcos = mxGetPr((mxArray *)prhs[6]); // length == 3
    REALTYPE__ *step = mxGetPr((mxArray *)prhs[7]); // length == 3
    REALTYPE__ *baseP = mxGetPr((mxArray *)prhs[8]); // length == 2
    REALTYPE__ *visstep = mxGetPr((mxArray *)prhs[9]); // length == 2
    REALTYPE__ posangle = mxGetScalar(prhs[10]);

    FARPROC fp;
    fp = GetProcAddress(hHSLib, TEXT("physSetField"));
    PROTO_physSetField psetfield = (PROTO_physSetField)fp;
    (psetfield)(fieldX, fieldY, fieldZ, M, N, vcos, step, baseP);

    plhs[0] = mxCreateNumericMatrix(1, 2, mxINT32_CLASS, mxREAL);
    int *Mout = (int *)mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericMatrix(1, 2, mxDOUBLE_CLASS, mxREAL);
    REALTYPE__ *minv = (REALTYPE__ *)mxGetPr(plhs[1]);

    BOOL bAutoCalc = TRUE;
    if (nrhs > 12)
    {
        bAutoCalc = FALSE;
        REALTYPE__ *M = mxGetPr((mxArray *)prhs[11]); // length == 2
        Mout[0] = (int)M[0]; Mout[1] = (int)M[1];
        REALTYPE__ *minvin = mxGetPr((mxArray *)prhs[12]); // length == 2
        minv[0] = minvin[0]; minv[1] = minvin[1];
    }

    fp = GetProcAddress(hHSLib, TEXT("physSetFieldPlaneMeshgridRect"));
    PROTO_physSetFieldPlaneMeshgridRect pgetfieldplane = (PROTO_physSetFieldPlaneMeshgridRect)fp;
    (pgetfieldplane)(visstep, posangle, Mout, minv, bAutoCalc);
}

