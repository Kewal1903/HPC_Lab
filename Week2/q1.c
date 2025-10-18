#include <stdio.h>
#include <omp.h>

int main() {
    printf("Illustrate Fork-Join pattern using parallel directive:\n");

    #pragma omp parallel
    {
        int tid = omp_get_thread_num();
        printf("Thread %d in parallel region\n", tid);
    } 

    printf("After join, back in serial region\n\n");

    printf("Fork-Join with multiple parallel directives and changing thread counts:\n");

    omp_set_num_threads(2);
    #pragma omp parallel
    {
        printf("First parallel region with 2 threads. Thread %d\n", omp_get_thread_num());
    }

    omp_set_num_threads(4);
    #pragma omp parallel
    {
        printf("Second parallel region with 4 threads. Thread %d\n", omp_get_thread_num());
    }
    printf("\n");

    printf("SPMD pattern using basic OpenMP commands:\n");

    #pragma omp parallel
    {
        int tid = omp_get_thread_num();
        int nthreads = omp_get_num_threads();

        printf("Thread %d of %d running SPMD pattern\n", tid, nthreads);
    }

    return 0;
}

