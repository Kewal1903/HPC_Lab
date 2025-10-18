#include <stdio.h>
#include <math.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    const int x = 2; 

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    double result = pow(x, rank);
    printf("Process %d: %d^%d = %.0f\n", rank, x, rank, result);

    MPI_Finalize();
    return 0;
}

