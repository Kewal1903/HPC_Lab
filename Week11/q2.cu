// 1D Tiled Convolution using Shared Memory
#include <stdio.h>

#define N 16
#define MASK_WIDTH 3
#define TILE_SIZE 8

__global__ void convolution1D_tiled(float *input, float *mask, float *output, int n) {
    __shared__ float s_Data[TILE_SIZE + MASK_WIDTH - 1];

    int tid = threadIdx.x;
    int global_idx = blockIdx.x * TILE_SIZE + tid;
    int radius = MASK_WIDTH / 2;

    // Load input elements into shared memory with halo
    int halo_left = blockIdx.x * TILE_SIZE - radius;

    if (halo_left + tid >= 0 && halo_left + tid < n)
        s_Data[tid] = input[halo_left + tid];
    else
        s_Data[tid] = 0.0f;

    __syncthreads();

    if (tid < TILE_SIZE && global_idx < n) {
        float result = 0.0f;
        for (int j = 0; j < MASK_WIDTH; j++)
            result += s_Data[tid + j] * mask[j];
        output[global_idx] = result;
    }
}

int main() {
    float h_Input[N], h_Output[N], h_Mask[MASK_WIDTH] = {1, 2, 1};

    for (int i = 0; i < N; i++)
        h_Input[i] = i + 1;

    float *d_Input, *d_Output, *d_Mask;
    cudaMalloc(&d_Input, N * sizeof(float));
    cudaMalloc(&d_Output, N * sizeof(float));
    cudaMalloc(&d_Mask, MASK_WIDTH * sizeof(float));

    cudaMemcpy(d_Input, h_Input, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_Mask, h_Mask, MASK_WIDTH * sizeof(float), cudaMemcpyHostToDevice);

    int numBlocks = (N + TILE_SIZE - 1) / TILE_SIZE;
    convolution1D_tiled<<<numBlocks, TILE_SIZE + MASK_WIDTH - 1>>>(d_Input, d_Mask, d_Output, N);

    cudaMemcpy(h_Output, d_Output, N * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i = 0; i < N; i++)
        printf("%.1f ", h_Output[i]);
    printf("\n");

    cudaFree(d_Input);
    cudaFree(d_Output);
    cudaFree(d_Mask);
    return 0;
}

/*
Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week11$ nvcc q2.cu
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week11$ ./a.out
Result:
4.0 8.0 12.0 16.0 20.0 24.0 28.0 32.0 36.0 40.0 44.0 48.0 52.0 56.0 60.0 47.0 

*/
