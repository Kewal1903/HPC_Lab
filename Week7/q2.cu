#include <stdio.h>
#include <cuda_runtime.h>

__global__ void convolution(int *input, int *mask, int *output, int N, int M) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int halfM = M / 2;

    if (idx >= halfM && idx < N - halfM) {
        int sum = 0;
        for (int i = -halfM; i <= halfM; i++) {
            sum += input[idx + i] * mask[halfM + i];
        }
        output[idx] = sum;
    }
}

int main() {
    int N = 1024;  // Number of elements in the input
    int M = 5;     // Size of the mask
    int *input, *mask, *output;
    int *d_input, *d_mask, *d_output;

    // Allocate host memory
    input = (int *)malloc(N * sizeof(int));
    mask = (int *)malloc(M * sizeof(int));
    output = (int *)malloc(N * sizeof(int));

    // Initialize input and mask
    for (int i = 0; i < N; i++) {
        input[i] = i;
    }
    for (int i = 0; i < M; i++) {
        mask[i] = 1;  // Simple averaging mask
    }

    // Allocate device memory
    cudaMalloc(&d_input, N * sizeof(int));
    cudaMalloc(&d_mask, M * sizeof(int));
    cudaMalloc(&d_output, N * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(d_input, input, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, M * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with block size 256
    int blockSize = 256;
    int gridSize = (N + blockSize - 1) / blockSize;
    convolution<<<gridSize, blockSize>>>(d_input, d_mask, d_output, N, M);

    // Copy result from device to host
    cudaMemcpy(output, d_output, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Verify result
    for (int i = 0; i < N; i++) {
        printf("output[%d] = %d\n", i, output[i]);
    }

    // Free memory
    free(input);
    free(mask);
    free(output);
    cudaFree(d_input);
    cudaFree(d_mask);
    cudaFree(d_output);

    return 0;
}
 /*
 Output:
 output[0] = 0
output[1] = 0
output[2] = 10
output[3] = 15
output[4] = 20
output[5] = 25
output[6] = 30
output[7] = 35
output[8] = 40
output[9] = 45
output[10] = 50
output[11] = 55
output[12] = 60
output[13] = 65
output[14] = 70
output[15] = 75
output[16] = 80
output[17] = 85
output[18] = 90
output[19] = 95
output[20] = 100
output[21] = 105
output[22] = 110
output[23] = 115
output[24] = 120
output[25] = 125
output[26] = 130

 
 */
