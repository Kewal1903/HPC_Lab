// conv2D.cu

#include <stdio.h>
#define N 5
#define MASK_WIDTH 3
#define TILE_WIDTH 3

__constant__ float d_Mask[MASK_WIDTH * MASK_WIDTH];

__global__ void conv2D(float* input, float* output, int width) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    float result = 0.0f;

    int maskRadius = MASK_WIDTH / 2;

    if (row < width && col < width) {
        for (int i = -maskRadius; i <= maskRadius; i++) {
            for (int j = -maskRadius; j <= maskRadius; j++) {
                int r = row + i;
                int c = col + j;
                if (r >= 0 && r < width && c >= 0 && c < width) {
                    result += input[r * width + c] *
                              d_Mask[(i + maskRadius) * MASK_WIDTH + (j + maskRadius)];
                }
            }
        }
        output[row * width + col] = result;
    }
}

int main() {
    float h_input[N * N], h_output[N * N], h_mask[MASK_WIDTH * MASK_WIDTH] = {
        0, -1, 0,
       -1, 5, -1,
        0, -1, 0
    };

    for (int i = 0; i < N * N; i++) h_input[i] = 1.0f;

    float *d_input, *d_output;
    cudaMalloc(&d_input, N * N * sizeof(float));
    cudaMalloc(&d_output, N * N * sizeof(float));

    cudaMemcpy(d_input, h_input, N * N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpyToSymbol(d_Mask, h_mask, MASK_WIDTH * MASK_WIDTH * sizeof(float));

    dim3 dimBlock(TILE_WIDTH, TILE_WIDTH);
    dim3 dimGrid((N + TILE_WIDTH - 1) / TILE_WIDTH, (N + TILE_WIDTH - 1) / TILE_WIDTH);
    conv2D<<<dimGrid, dimBlock>>>(d_input, d_output, N);
    cudaMemcpy(h_output, d_output, N * N * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Full 2D Output:\n");
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            printf("%6.1f ", h_output[i * N + j]);
        }
        printf("\n");
    }

    cudaFree(d_input); cudaFree(d_output);
    return 0;
}

/* Output
Full 2D Output:
   3.0    2.0    2.0    2.0    3.0 
   2.0    1.0    1.0    1.0    2.0 
   2.0    1.0    1.0    1.0    2.0 
   2.0    1.0    1.0    1.0    2.0 
   3.0    2.0    2.0    2.0    3.0 

*/
