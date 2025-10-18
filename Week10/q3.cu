// spmv_csr.cu

#include <stdio.h>

__global__ void spmv_csr_kernel(int* row_ptr, int* col_idx, float* values, float* x, float* y, int num_rows) {
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < num_rows) {
        float dot = 0.0f;
        int row_start = row_ptr[row];
        int row_end = row_ptr[row + 1];

        for (int j = row_start; j < row_end; j++) {
            dot += values[j] * x[col_idx[j]];
        }
        y[row] = dot;
    }
}

int main() {
    // Example CSR representation of 3x3 matrix
    // [10 0 0]
    // [0 20 0]
    // [0 0 30]
    int h_row_ptr[] = {0, 1, 2, 3};
    int h_col_idx[] = {0, 1, 2};
    float h_values[] = {10.0f, 20.0f, 30.0f};
    float h_x[] = {1.0f, 2.0f, 3.0f};
    float h_y[3];

    int *d_row_ptr, *d_col_idx;
    float *d_values, *d_x, *d_y;

    cudaMalloc(&d_row_ptr, 4 * sizeof(int));
    cudaMalloc(&d_col_idx, 3 * sizeof(int));
    cudaMalloc(&d_values, 3 * sizeof(float));
    cudaMalloc(&d_x, 3 * sizeof(float));
    cudaMalloc(&d_y, 3 * sizeof(float));

    cudaMemcpy(d_row_ptr, h_row_ptr, 4 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_idx, h_col_idx, 3 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_values, h_values, 3 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, h_x, 3 * sizeof(float), cudaMemcpyHostToDevice);

    spmv_csr_kernel<<<1, 3>>>(d_row_ptr, d_col_idx, d_values, d_x, d_y, 3);
    cudaMemcpy(h_y, d_y, 3 * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Output Vector y:\n");
    for (int i = 0; i < 3; ++i) {
        printf("y[%d] = %.1f\n", i, h_y[i]);
    }


    cudaFree(d_row_ptr); cudaFree(d_col_idx); cudaFree(d_values);
    cudaFree(d_x); cudaFree(d_y);
    return 0;
}

/* Output:
Output Vector y:
y[0] = 10.0
y[1] = 40.0
y[2] = 90.0
*/
