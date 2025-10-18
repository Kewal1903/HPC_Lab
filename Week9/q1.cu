// q1_power_rows.cu
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void power_rows(int *A, int M, int N) {
    int r = blockIdx.y * blockDim.y + threadIdx.y;
    int c = blockIdx.x * blockDim.x + threadIdx.x;
    if (r < M && c < N) {
        int val = A[r * N + c];
        int p = r + 1;
        int out = 1;
        for (int i = 0; i < p; i++) {
            out *= val;
        }
        A[r * N + c] = out;
    }
}

int main() {
    int M = 4, N = 5;
    int h_A[M*N];
    for (int i = 0; i < M*N; i++) h_A[i] = i + 1;

    int *d_A;
    cudaMalloc(&d_A, M * N * sizeof(int));
    cudaMemcpy(d_A, h_A, M * N * sizeof(int), cudaMemcpyHostToDevice);

    dim3 block(16, 16);
    dim3 grid((N + block.x - 1)/block.x, (M + block.y - 1)/block.y);

    power_rows<<<grid, block>>>(d_A, M, N);
    cudaMemcpy(h_A, d_A, M * N * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Q1: Matrix after row-wise powers:\n");
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            printf("%d ", h_A[i * N + j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    return 0;
}

/*
Q1: Matrix after row-wise powers:
1 2 3 4 5 
36 49 64 81 100 
1331 1728 2197 2744 3375 
65536 83521 104976 130321 160000
*/
