#include "mex.h"
#include <stdlib.h>
#include <stdbool.h>

#define greater(a,b) ((a) > (b)+threshold)

void mexFunction(int nout, mxArray *out[], int nin, const mxArray *in[]) {
    // Validate input arguments
    if (nin < 1) {
        mexErrMsgTxt("At least one input required.");
    } else if (nin > 3) {
        mexErrMsgTxt("At most three input arguments are allowed.");
    } else if (nout > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }

    // Validate input matrix
    if (!mxIsDouble(in[0]) || mxIsComplex(in[0])) {
        mexErrMsgTxt("Input must be a real matrix.");
    }

    // Threshold argument
    double threshold = (nin > 1) ? mxGetScalar(in[1]) : -mxGetInf();

    // Dimensionality of the input matrix
    const mwSize *dims = mxGetDimensions(in[0]);
    int ndims = mxGetNumberOfDimensions(in[0]);
    mexPrintf("Number of dimensions: %d\n", ndims);

    // Dimensions handling
    int M = dims[0];
    int N = dims[1];
    int O = (ndims == 3) ? dims[2] : 1; // Handle 2D and 3D cases

    mexPrintf("Assigned Dimensions: M = %d, N = %d, O = %d\n", M, N, O);

    // Pointer to the input matrix
    const double *F_pt = mxGetPr(in[0]);

    // Variables for local maxima search
    int maxima_size = M * N * O;
    int *maxima_start = (int *)mxMalloc(sizeof(int) * maxima_size);
    int *maxima_iterator = maxima_start;
    int *maxima_end = maxima_start + maxima_size;

    // Loop over all elements
    for (int z = 1; z < O - 1; ++z) {
        for (int y = 1; y < N - 1; ++y) {
            for (int x = 1; x < M - 1; ++x) {
                int idx = x + M * (y + N * z);
                double v = F_pt[idx];
                bool is_maxima = true;

                // Check all neighbors
                for (int dz = -1; dz <= 1 && is_maxima; ++dz) {
                    for (int dy = -1; dy <= 1 && is_maxima; ++dy) {
                        for (int dx = -1; dx <= 1 && is_maxima; ++dx) {
                            if (dx == 0 && dy == 0 && dz == 0) continue;
                            int n_idx = idx + dx + M * (dy + N * dz);
                            if (v <= F_pt[n_idx]) {
                                is_maxima = false;
                            }
                        }
                    }
                }

                // Add local maximum
                if (is_maxima) {
                    *maxima_iterator++ = idx + 1; // Matlab index starts from 1
                    if (maxima_iterator == maxima_end) {
                        maxima_size += M * N * O;
                        maxima_start = (int *)mxRealloc(maxima_start, maxima_size * sizeof(int));
                        maxima_end = maxima_start + maxima_size;
                        maxima_iterator = maxima_end - M * N * O;
                    }
                }
            }
        }
    }

    // Return results
    int num_maxima = maxima_iterator - maxima_start;
    out[0] = mxCreateDoubleMatrix(1, num_maxima, mxREAL);
    double *M_pt = mxGetPr(out[0]);
    for (int i = 0; i < num_maxima; ++i) {
        M_pt[i] = maxima_start[i];
    }

    // Clean up
    mxFree(maxima_start);
}
