#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// CUDA Kernel: Checks for word matches and increments a global counter
__global__ void count_word_repeats_kernel(const char* sentence, int sentence_len, 
                                          const char* word_to_find, int word_len, 
                                          int* d_count) {
    // Calculate the index for the thread
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    
    // We only need to check up to the point where the full word can still fit
    if (idx <= sentence_len - word_len) {
        bool match = true;
        
        // Check if the substring starting at idx matches the word_to_find
        for (int i = 0; i < word_len; i++) {
            if (sentence[idx + i] != word_to_find[i]) {
                match = false;
                break;
            }
        }
        
        // Additional check: Ensure it's a *whole word* match (simple version)
        // Check for preceding space/start-of-string and succeeding space/end-of-string
        bool preceding_boundary = (idx == 0) || (sentence[idx - 1] == ' ');
        bool succeeding_boundary = (idx + word_len == sentence_len) || (sentence[idx + word_len] == ' ');

        if (match && preceding_boundary && succeeding_boundary) {
            // **Critical step: Use atomicAdd for safe parallel increment**
            atomicAdd(d_count, 1);
        }
    }
}

void count_word_repeats(const char* sentence, const char* word_to_find) {
    int sentence_len = strlen(sentence);
    int word_len = strlen(word_to_find);
    
    if (word_len == 0 || sentence_len < word_len) {
        printf("Invalid input or word too long.\n");
        return;
    }

    char *d_sentence, *d_word;
    int *d_count;
    int h_count = 0; // Host counter initialized to 0

    // Allocate device memory
    cudaMalloc((void**)&d_sentence, sentence_len * sizeof(char) + 1);
    cudaMalloc((void**)&d_word, word_len * sizeof(char) + 1);
    cudaMalloc((void**)&d_count, sizeof(int));
    
    // Copy input data and initialize counter on device
    cudaMemcpy(d_sentence, sentence, sentence_len * sizeof(char) + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_word, word_to_find, word_len * sizeof(char) + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &h_count, sizeof(int), cudaMemcpyHostToDevice);
    
    // --- Kernel Launch Configuration ---
    // Launch a thread for every possible starting position of the word
    int threads_per_block = 256;
    int num_blocks = (sentence_len + threads_per_block - 1) / threads_per_block;

    // Launch the kernel
    count_word_repeats_kernel<<<num_blocks, threads_per_block>>>(
        d_sentence, sentence_len, d_word, word_len, d_count);

    cudaDeviceSynchronize();

    // Copy the final count back to host
    cudaMemcpy(&h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);

    // Print the result
    printf("Sentence: %s\n", sentence);
    printf("Word to find: %s\n", word_to_find);
    printf("Word Repeat Count: %d\n", h_count);

    // Cleanup
    cudaFree(d_sentence);
    cudaFree(d_word);
    cudaFree(d_count);
}

int main() {
    // Note the space boundaries are important for the simple word check in the kernel
    char sentence_input[] = "the quick brown fox jumps over the lazy dog and the fox";
    char word_input[] = "the";
    
    count_word_repeats(sentence_input, word_input);
    
    // Expected output: 3 (the is at start, middle, and before the final ' fox')
    
    return 0;
}


/*
Output:
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week8$ nvcc q3.cu
STUDENT@MIT-ICT-LAB5-06:~/230968126_Kewal/week8$ ./a.out
Sentence: the quick brown fox jumps over the lazy dog and the fox
Word to find: the
Word Repeat Count: 3


*/
