#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// CUDA Kernel: Each thread copies the entire string S once
__global__ void repeat_string_kernel(const char* s_in, char* s_out, int len_s, int n) {
    // Calculate the index for the thread
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // Check if the thread is within the N repetitions
    if (idx < n) {
        // The starting position in the output buffer for this thread
        int start_pos = idx * len_s;

        // Copy the entire string S (len_s characters)
        for (int i = 0; i < len_s; i++) {
            s_out[start_pos + i] = s_in[i];
        }
    }
}

void repeat_string(const char* s, int n) {
    int len_s = strlen(s);
    int total_len = len_s * n;
    
    // Allocate host memory for the result
    char* h_out = (char*)malloc(total_len + 1);
    
    // Pointers for device memory
    char *d_in, *d_out;
    
    // Allocate device memory
    cudaMalloc((void**)&d_in, len_s * sizeof(char));
    cudaMalloc((void**)&d_out, total_len * sizeof(char));
    
    // Copy input string to device
    cudaMemcpy(d_in, s, len_s * sizeof(char), cudaMemcpyHostToDevice);

    // --- Kernel Launch Configuration ---
    // Since each thread copies the *entire* string S, we only need N threads.
    int threads_per_block = 256;
    int num_blocks = (n + threads_per_block - 1) / threads_per_block;

    // Launch the kernel
    repeat_string_kernel<<<num_blocks, threads_per_block>>>(d_in, d_out, len_s, n);

    // Wait for the device to finish
    cudaDeviceSynchronize();

    // Copy result back to host
    cudaMemcpy(h_out, d_out, total_len * sizeof(char), cudaMemcpyDeviceToHost);
    h_out[total_len] = '\0'; // Null-terminate the output string
    
    // Print the result
    printf("Input String (S): %s\n", s);
    printf("Repetitions (N): %d\n", n);
    printf("Output String: %s\n", h_out);

    // Cleanup
    free(h_out);
    cudaFree(d_in);
    cudaFree(d_out);
}

int main() {
    char s_input[] = "Hello";
    int n_input = 3;
    
    repeat_string(s_input, n_input);
    
    return 0;
}


/*
Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week8$ ./a.out
Input String (S): Hello
Repetitions (N): 3
Output String: HelloHelloHello

*/
