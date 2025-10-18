#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(int *A, int *B, int *C, int N) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < N) {
        C[idx] = A[idx] + B[idx];
    }
}

int main() {
    int N = 1024;  // Size of vectors
    int *A, *B, *C;
    int *d_A, *d_B, *d_C;

    // Allocate host memory
    A = (int *)malloc(N * sizeof(int));
    B = (int *)malloc(N * sizeof(int));
    C = (int *)malloc(N * sizeof(int));

    // Initialize vectors A and B
    for (int i = 0; i < N; i++) {
        A[i] = i;
        B[i] = i * 2;
    }

    // Allocate device memory
    cudaMalloc(&d_A, N * sizeof(int));
    cudaMalloc(&d_B, N * sizeof(int));
    cudaMalloc(&d_C, N * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(d_A, A, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with block size N
    vectorAdd<<<1, N>>>(d_A, d_B, d_C, N);

    // Copy result from device to host
    cudaMemcpy(C, d_C, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Verify result
    for (int i = 0; i < N; i++) {
        printf("%d + %d = %d\n", A[i], B[i], C[i]);
    }

    // Free memory
    free(A);
    free(B);
    free(C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}


/*
Output: (Q1a - Q1c)
0 + 0 = 0
1 + 2 = 3
2 + 4 = 6
3 + 6 = 9
4 + 8 = 12
5 + 10 = 15
6 + 12 = 18
7 + 14 = 21
8 + 16 = 24
9 + 18 = 27
10 + 20 = 30
11 + 22 = 33
12 + 24 = 36
13 + 26 = 39
14 + 28 = 42
15 + 30 = 45

*/
