#pragma once
double* amxGetDoubleArray(int nrhs, const mxArray *prhs[], int idx);
int* amxGetIntArray(int nrhs, const mxArray *prhs[], int idx);
UINT64* amxGetUINT64Array(int nrhs, const mxArray *prhs[], int idx);
double amxGetDoubleScalar(int nrhs, const mxArray *prhs[], int idx, double deflt);
int amxGetIntScalar(int nrhs, const mxArray *prhs[], int idx, int deflt);
UINT64 amxGetUINT64Scalar(int nrhs, const mxArray *prhs[], int idx, UINT64 deflt);
double *amxCreateDoubleArray(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny);
int *amxCreateIntArray(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny);
UINT64 *amxCreateUINT64Array(int nlhs, mxArray *plhs[], int idx, mwSize nx, mwSize ny);
