#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

void mat_vec_mult(int **A, int *x, int *y, int n) {
    #pragma omp parallel for
    for(int i=0; i<n; i++) {
        y[i] = 0;
        for(int j=0; j<n; j++) {
            y[i] += A[i][j] * x[j];
        }
    }
}

int main() {
    int sizes[] = {200, 400, 600, 800, 1000};
    int threads[] = {2, 4, 6, 8};
    int num_sizes = sizeof(sizes)/sizeof(sizes[0]);
    int num_threads = sizeof(threads)/sizeof(threads[0]);

    for(int idx = 0; idx < num_sizes; idx++) {
        int n = sizes[idx];

        int **A = malloc(n * sizeof(int*));
        int *x = malloc(n * sizeof(int));
        int *y = malloc(n * sizeof(int));
        for(int i=0; i<n; i++)
            A[i] = malloc(n * sizeof(int));

        for(int i=0; i<n; i++) {
            x[i] = i;
            for(int j=0; j<n; j++)
                A[i][j] = i + j;
        }
        omp_set_num_threads(1);
        double start = omp_get_wtime();
        mat_vec_mult(A, x, y, n);
        double serial_time = omp_get_wtime() - start;
        printf("Matrix-Vector Size: %d\n", n);
        printf("Threads\tTime(s)\tSpeedup\tEfficiency\n");
        for(int t=0; t<num_threads; t++) {
            omp_set_num_threads(threads[t]);
            start = omp_get_wtime();
            mat_vec_mult(A, x, y, n);
            double par_time = omp_get_wtime() - start;

            double speedup = serial_time / par_time;
            double efficiency = speedup / threads[t];

            printf("%d\t%f\t%.2f\t%.2f\n", threads[t], par_time, speedup, efficiency);
        }
        printf("\n");
        for(int i=0; i<n; i++) free(A[i]);
        free(A); free(x); free(y);
    }
    return 0;
}

