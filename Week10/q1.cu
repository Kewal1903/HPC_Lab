// matrixMul.cu

#include <stdio.h>
#define N 512

__global__ void matrixMulKernel(float* A, float* B, float* C, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y; // Row index
    int col = blockIdx.x * blockDim.x + threadIdx.x; // Column index

    if (row < n && col < n) {
        float value = 0.0f;
        for (int k = 0; k < n; ++k)
            value += A[row * n + k] * B[k * n + col];
        C[row * n + col] = value;
    }
}

int main() {
    int size = N * N * sizeof(float);
    float *A, *B, *C;
    float *d_A, *d_B, *d_C;

    A = (float*)malloc(size);
    B = (float*)malloc(size);
    C = (float*)malloc(size);

    for (int i = 0; i < N * N; ++i) {
        A[i] = 1.0f; B[i] = 1.0f;
    }

    cudaMalloc(&d_A, size); cudaMalloc(&d_B, size); cudaMalloc(&d_C, size);
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    dim3 dimBlock(16, 16);
    dim3 dimGrid((N + dimBlock.x - 1) / dimBlock.x,
                 (N + dimBlock.y - 1) / dimBlock.y);
    matrixMulKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C, N);
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    printf("Full 2D Output Matrix C (showing first 10x10):\n");
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
            printf("%7.1f ", C[i * N + j]);
        }
        printf("\n");
    }


    cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
    free(A); free(B); free(C);
    return 0;
}

/* Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week10$ ./a.out
Full 2D Output Matrix C (showing first 10x10):
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
  512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0   512.0 
*/
