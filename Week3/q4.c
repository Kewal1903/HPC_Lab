#include <stdio.h>
#include <omp.h>

#define N 1000

int main() {
    int arr[N];
    for (int i = 0; i < N; i++) arr[i] = 1; 

    int sum_critical = 0;
    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        #pragma omp critical
        sum_critical += arr[i];
    }
    printf("Sum using critical: %d\n", sum_critical);

    int sum_atomic = 0;
    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        #pragma omp atomic
        sum_atomic += arr[i];
    }
    printf("Sum using atomic: %d\n", sum_atomic);

    int sum_reduction = 0;
    #pragma omp parallel for reduction(+:sum_reduction)
    for (int i = 0; i < N; i++) {
        sum_reduction += arr[i];
    }
    printf("Sum using reduction: %d\n", sum_reduction);

    int sum_master = 0;
    #pragma omp parallel
    {
        int local_sum = 0;
        #pragma omp for
        for (int i = 0; i < N; i++) {
            local_sum += arr[i];
        }

        #pragma omp master
        {
            sum_master = local_sum; 
        }
    }
    printf("Sum using master (may not be correct total): %d\n", sum_master);

    omp_lock_t lock;
    omp_init_lock(&lock);
    int sum_lock = 0;
    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        omp_set_lock(&lock);
        sum_lock += arr[i];
        omp_unset_lock(&lock);
    }
    omp_destroy_lock(&lock);
    printf("Sum using locks: %d\n", sum_lock);

    return 0;
}

