#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

// CUDA kernel to calculate sine of each angle in the input array
__global__ void sineOfAngles(float *input, float *output, int N) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < N) {
        output[idx] = sin(input[idx]);  // Calculate sine of the angle at input[idx]
    }
}

int main() {
    int N = 1024;  // Number of elements
    float *input, *output;
    float *d_input, *d_output;

    // Allocate host memory
    input = (float*)malloc(N * sizeof(float));
    output = (float*)malloc(N * sizeof(float));

    // Initialize input array with angles (in radians)
    for (int i = 0; i < N; i++) {
        input[i] = i * (M_PI / 180.0f);  // Convert degrees to radians (for example)
    }

    // Allocate device memory
    cudaMalloc((void**)&d_input, N * sizeof(float));
    cudaMalloc((void**)&d_output, N * sizeof(float));

    // Copy input data from host to device
    cudaMemcpy(d_input, input, N * sizeof(float), cudaMemcpyHostToDevice);

    // Launch kernel with 256 threads per block
    int blockSize = 256;
    int gridSize = (N + blockSize - 1) / blockSize;  // Number of blocks
    sineOfAngles<<<gridSize, blockSize>>>(d_input, d_output, N);

    // Copy the result from device to host
    cudaMemcpy(output, d_output, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Print the results
    for (int i = 0; i < N; i++) {
        printf("sin(%f) = %f\n", input[i], output[i]);
    }

    // Free device and host memory
    free(input);
    free(output);
    cudaFree(d_input);
    cudaFree(d_output);

    return 0;
}

/*
Output:
sin(0.000000) = 0.000000
sin(0.017453) = 0.017452
sin(0.034907) = 0.034899
sin(0.052360) = 0.052336
sin(0.069813) = 0.069756
sin(0.087266) = 0.087156
sin(0.104720) = 0.104528
sin(0.122173) = 0.121869
sin(0.139626) = 0.139173
sin(0.157080) = 0.156434
sin(0.174533) = 0.173648
sin(0.191986) = 0.190809
sin(0.209440) = 0.207912
sin(0.226893) = 0.224951
sin(0.244346) = 0.241922
sin(0.261799) = 0.258819
sin(0.279253) = 0.275637
sin(0.296706) = 0.292372
sin(0.314159) = 0.309017
sin(0.331613) = 0.325568
sin(0.349066) = 0.342020
sin(0.366519) = 0.358368
sin(0.383972) = 0.374607
sin(0.401426) = 0.390731
sin(0.418879) = 0.406737
sin(0.436332) = 0.422618

*/
