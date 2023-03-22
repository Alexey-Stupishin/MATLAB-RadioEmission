// MEX wrapper
//
// mex -v -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\utilsFreeLibrary.cpp -outdir s:\Projects\Conveyor\MATLAB
// mex -v -g -largeArrayDims s:\Projects\Matlab\Calculations\GyroSync\utilsFreeLibrary.cpp -outdir s:\Projects\Conveyor\MATLAB
//

#include <Windows.h>

#include "mex.h"

//-------------------------------------------------------------------------------------
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    FreeLibrary((HINSTANCE)*(UINT64 *)mxGetData(prhs[0]));
}
