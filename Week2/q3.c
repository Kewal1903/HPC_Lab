#include <stdio.h>
#include <omp.h>
int main() {
    int arr[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int n = sizeof(arr)/sizeof(arr[0]);
    int even_sum = 0, odd_sum = 0;
    #pragma omp parallel sections
    {
        #pragma omp section
        {
            for(int i=0; i<n; i++) {
                if(arr[i] % 2 == 0) even_sum += arr[i];
            }
        }
        #pragma omp section
        {
            for(int i=0; i<n; i++) {
                if(arr[i] % 2 != 0) odd_sum += arr[i];
            }
        }
    }
    printf("Sum of even numbers = %d\n", even_sum);
    printf("Sum of odd numbers = %d\n", odd_sum);
    return 0;
}

