#include <stdio.h>
#include <omp.h>
#include <math.h>
int main() {
    int i = 2; 
    #pragma omp parallel
    {
        int tid = omp_get_thread_num();
        double result = pow(i, tid);
        printf("Thread %d: %d^%d = %.0f\n", tid, i, tid, result);
    }
    return 0;
}

