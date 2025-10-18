#include <stdio.h>
#include <omp.h>

#define SIZE 5

int main() {
    int A[SIZE] = {1, 2, 3, 4, 5};
    int B[SIZE] = {5, 4, 3, 2, 1};
    int sum[SIZE], diff[SIZE], prod[SIZE];

    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task
            for (int i = 0; i < SIZE; i++)
                sum[i] = A[i] + B[i];

            #pragma omp task
            for (int i = 0; i < SIZE; i++)
                diff[i] = A[i] - B[i];

            #pragma omp task
            for (int i = 0; i < SIZE; i++)
                prod[i] = A[i] * B[i];
        }
    }

    printf("Addition: ");
    for (int i = 0; i < SIZE; i++) printf("%d ", sum[i]);

    printf("\nSubtraction: ");
    for (int i = 0; i < SIZE; i++) printf("%d ", diff[i]);

    printf("\nMultiplication: ");
    for (int i = 0; i < SIZE; i++) printf("%d ", prod[i]);

    return 0;
}

