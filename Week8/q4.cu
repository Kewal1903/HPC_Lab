#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// CUDA Kernel: Swaps character pairs from the outside in
__global__ void reverse_string_kernel(char* s, int len) {
    // Calculate the index for the thread
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    
    // We only need threads for half the length of the string to perform all swaps
    if (tid < len / 2) {
        int left_idx = tid;
        int right_idx = len - 1 - tid; // Character at the opposite end

        // Perform the swap
        char temp = s[left_idx];
        s[left_idx] = s[right_idx];
        s[right_idx] = temp;
    }
}

void reverse_entire_string(char* s) {
    int len_s = strlen(s);
    char* d_s;
    
    // Allocate and copy string to device
    cudaMalloc((void**)&d_s, len_s + 1);
    cudaMemcpy(d_s, s, len_s + 1, cudaMemcpyHostToDevice);
    
    // --- Kernel Launch Configuration ---
    // Threads needed is (len_s / 2)
    int threads_per_block = 256;
    int num_threads_needed = len_s / 2;
    int num_blocks = (num_threads_needed + threads_per_block - 1) / threads_per_block;

    printf("Input String: %s\n", s);
    
    // Launch the kernel
    reverse_string_kernel<<<num_blocks, threads_per_block>>>(d_s, len_s);

    cudaDeviceSynchronize();

    // Copy result back
    cudaMemcpy(s, d_s, len_s + 1, cudaMemcpyDeviceToHost);
    
    printf("Output String (Entire String Reversed): %s\n", s);

    // Cleanup
    cudaFree(d_s);
}

int main() {
    char s_input[] = "I love parallel computing";
    reverse_entire_string(s_input);
    
    // Expected output: gnitupmoc llelarap evol I
    
    return 0;
}

/*
Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week8$ ./a.out
Input String: I love parallel computing
Output String (Entire String Reversed): gnitupmoc lellarap evol I

*/
