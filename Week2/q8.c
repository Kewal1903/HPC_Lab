#include <stdio.h>
#include <omp.h>
int fibonacci(int n) {
    if(n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

int main() {
    int A[] = {10, 13, 5, 6};
    int n = sizeof(A)/sizeof(A[0]);
    int fib_results[4];

    #pragma omp parallel for
    for(int i = 0; i < n; i++) {
        fib_results[i] = fibonacci(A[i]);
        printf("Thread %d computed fibonacci(%d) = %d\n", omp_get_thread_num(), A[i], fib_results[i]);
    }
    return 0;
}

