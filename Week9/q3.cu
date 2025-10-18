// q3_matrix_multiplication.cu
#include <stdio.h>
#include <cuda_runtime.h>

// (a) One thread per row
__global__ void mul_rows(int *A, int *B, int *C, int M, int K, int N) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < M) {
        for (int j = 0; j < N; j++) {
            int sum = 0;
            for (int k = 0; k < K; k++) {
                sum += A[i * K + k] * B[k * N + j];
            }
            C[i * N + j] = sum;
        }
    }
}

// (b) One thread per column
__global__ void mul_cols(int *A, int *B, int *C, int M, int K, int N) {
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if (j < N) {
        for (int i = 0; i < M; i++) {
            int sum = 0;
            for (int k = 0; k < K; k++) {
                sum += A[i * K + k] * B[k * N + j];
            }
            C[i * N + j] = sum;
        }
    }
}

// (c) One thread per element
__global__ void mul_elem(int *A, int *B, int *C, int M, int K, int N) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < M && j < N) {
        int sum = 0;
        for (int k = 0; k < K; k++) {
            sum += A[i * K + k] * B[k * N + j];
        }
        C[i * N + j] = sum;
    }
}

void printMatrix(int *M, int rows, int cols, const char *name) {
    printf("%s:\n", name);
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++)
            printf("%d ", M[i * cols + j]);
        printf("\n");
    }
    printf("\n");
}

int main() {
    int M = 4, K = 3, N = 5;
    int sizeA = M * K;
    int sizeB = K * N;
    int sizeC = M * N;

    int *h_A = (int *)malloc(sizeA * sizeof(int));
    int *h_B = (int *)malloc(sizeB * sizeof(int));
    int *h_C = (int *)malloc(sizeC * sizeof(int));

    for (int i = 0; i < sizeA; i++) h_A[i] = i + 1;
    for (int i = 0; i < sizeB; i++) h_B[i] = (i + 1) * 2;

    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, sizeA * sizeof(int));
    cudaMalloc(&d_B, sizeB * sizeof(int));
    cudaMalloc(&d_C, sizeC * sizeof(int));

    cudaMemcpy(d_A, h_A, sizeA * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, sizeB * sizeof(int), cudaMemcpyHostToDevice);

    // (a) Multiply by row threads
    {
        int threads = 128;
        int blocks = (M + threads - 1) / threads;
        mul_rows<<<blocks, threads>>>(d_A, d_B, d_C, M, K, N);
        cudaMemcpy(h_C, d_C, sizeC * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q3a: Mul (one thread per row)");
    }

    // (b) Multiply by column threads
    {
        int threads = 128;
        int blocks = (N + threads - 1) / threads;
        mul_cols<<<blocks, threads>>>(d_A, d_B, d_C, M, K, N);
        cudaMemcpy(h_C, d_C, sizeC * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q3b: Mul (one thread per column)");
    }

    // (c) Multiply by element threads
    {
        dim3 block(16, 16);
        dim3 grid((N + block.x - 1) / block.x, (M + block.y - 1) / block.y);
        mul_elem<<<grid, block>>>(d_A, d_B, d_C, M, K, N);
        cudaMemcpy(h_C, d_C, sizeC * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q3c: Mul (one thread per element)");
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}

/*
Q3a: Mul (one thread per row):
92 104 116 128 140 
200 230 260 290 320 
308 356 404 452 500 
416 482 548 614 680 

*/
