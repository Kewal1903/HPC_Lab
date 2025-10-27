// 1D Convolution using Constant Memory
#include <stdio.h>

#define N 16        // Input size
#define MASK_WIDTH 3
#define TILE_SIZE N

__constant__ float d_Mask[MASK_WIDTH]; // Constant memory for mask

__global__ void convolution1D(float *input, float *output, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    float result = 0.0f;

    int radius = MASK_WIDTH / 2;

    if (i < n) {
        for (int j = -radius; j <= radius; j++) {
            int idx = i + j;
            if (idx >= 0 && idx < n)
                result += input[idx] * d_Mask[j + radius];
        }
        output[i] = result;
    }
}

int main() {
    float h_Input[N], h_Output[N];
    float h_Mask[MASK_WIDTH] = {1, 2, 1};

    for (int i = 0; i < N; i++)
        h_Input[i] = i + 1;

    float *d_Input, *d_Output;
    cudaMalloc(&d_Input, N * sizeof(float));
    cudaMalloc(&d_Output, N * sizeof(float));

    cudaMemcpy(d_Input, h_Input, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpyToSymbol(d_Mask, h_Mask, MASK_WIDTH * sizeof(float)); // Copy mask to constant memory

    convolution1D<<<1, TILE_SIZE>>>(d_Input, d_Output, N);
    cudaMemcpy(h_Output, d_Output, N * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i = 0; i < N; i++)
        printf("%.1f ", h_Output[i]);
    printf("\n");

    cudaFree(d_Input);
    cudaFree(d_Output);
    return 0;
}

/*
Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week11$ nvcc q1.cu
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week11$ ./a.out
Result:
4.0 8.0 12.0 16.0 20.0 24.0 28.0 32.0 36.0 40.0 44.0 48.0 52.0 56.0 60.0 47.0 
*/
