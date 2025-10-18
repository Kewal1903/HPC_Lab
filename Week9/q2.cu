// q2_matrix_addition.cu
#include <stdio.h>
#include <cuda_runtime.h>

// (a) One thread per row
__global__ void add_rows(int *A, int *B, int *C, int M, int N) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    if (r < M) {
        for (int c = 0; c < N; c++) {
            C[r * N + c] = A[r * N + c] + B[r * N + c];
        }
    }
}

// (b) One thread per column
__global__ void add_cols(int *A, int *B, int *C, int M, int N) {
    int c = blockIdx.x * blockDim.x + threadIdx.x;
    if (c < N) {
        for (int r = 0; r < M; r++) {
            C[r * N + c] = A[r * N + c] + B[r * N + c];
        }
    }
}

// (c) One thread per element
__global__ void add_elem(int *A, int *B, int *C, int M, int N) {
    int r = blockIdx.y * blockDim.y + threadIdx.y;
    int c = blockIdx.x * blockDim.x + threadIdx.x;
    if (r < M && c < N) {
        C[r * N + c] = A[r * N + c] + B[r * N + c];
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
    int M = 4, N = 5;
    int size = M * N;

    int *h_A = (int *)malloc(size * sizeof(int));
    int *h_B = (int *)malloc(size * sizeof(int));
    int *h_C = (int *)malloc(size * sizeof(int));

    // Initialize A and B
    for (int i = 0; i < size; i++) {
        h_A[i] = i + 1;
        h_B[i] = (i + 1) * 10;
    }

    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size * sizeof(int));
    cudaMalloc(&d_B, size * sizeof(int));
    cudaMalloc(&d_C, size * sizeof(int));

    cudaMemcpy(d_A, h_A, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size * sizeof(int), cudaMemcpyHostToDevice);

    // (a) Add by row threads
    {
        int threads = 128;
        int blocks = (M + threads - 1) / threads;
        add_rows<<<blocks, threads>>>(d_A, d_B, d_C, M, N);
        cudaMemcpy(h_C, d_C, size * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q2a: Add (one thread per row)");
    }

    // (b) Add by column threads
    {
        int threads = 128;
        int blocks = (N + threads - 1) / threads;
        add_cols<<<blocks, threads>>>(d_A, d_B, d_C, M, N);
        cudaMemcpy(h_C, d_C, size * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q2b: Add (one thread per column)");
    }

    // (c) Add by element threads
    {
        dim3 block(16, 16);
        dim3 grid((N + block.x - 1) / block.x, (M + block.y - 1) / block.y);
        add_elem<<<grid, block>>>(d_A, d_B, d_C, M, N);
        cudaMemcpy(h_C, d_C, size * sizeof(int), cudaMemcpyDeviceToHost);
        printMatrix(h_C, M, N, "Q2c: Add (one thread per element)");
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
Q2a: Add (one thread per row):
11 22 33 44 55 
66 77 88 99 110 
121 132 143 154 165 
176 187 198 209 220 
*/
