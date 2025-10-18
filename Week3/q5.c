#include <stdio.h>
#include <omp.h>

int main() {
    int start = 1, end = 1000000;
    long long sum = 0;

    #pragma omp parallel for reduction(+:sum)
    for (int i = start; i <= end; i++) {
        sum += i;
    }

    printf("Sum from %d to %d is: %lld\n", start, end, sum);
    return 0;
}

