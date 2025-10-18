#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

int main() {
    long long total_points = 100000000;
    long long points_in_circle = 0;
    #pragma omp parallel
    {
        unsigned int seed = (unsigned int)time(NULL) ^ omp_get_thread_num();
        long long local_count = 0;
        #pragma omp for
        for (long long i = 0; i < total_points; i++) {
            double x = (double)rand_r(&seed) / RAND_MAX;
            double y = (double)rand_r(&seed) / RAND_MAX;
            if ((x * x + y * y) <= 1.0) {
                local_count++;
            }
        }

        #pragma omp atomic
        points_in_circle += local_count;
    }
    double pi = 4.0 * points_in_circle / total_points;
    printf("Estimated value of π: %.10f\n", pi);
    return 0;
}

