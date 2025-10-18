#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    double a = 20.0, b = 10.0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size < 4) {
        if (rank == 0)
            printf("Please run with at least 4 processes.\n");
        MPI_Finalize();
        return 0;
    }

    switch (rank) {
        case 0:
            printf("Addition (%.2f + %.2f) = %.2f\n", a, b, a + b);
            break;
        case 1:
            printf("Subtraction (%.2f - %.2f) = %.2f\n", a, b, a - b);
            break;
        case 2:
            printf("Multiplication (%.2f * %.2f) = %.2f\n", a, b, a * b);
            break;
        case 3:
            if (b != 0)
                printf("Division (%.2f / %.2f) = %.2f\n", a, b, a / b);
            else
                printf("Division by zero is not allowed.\n");
            break;
        default:
            printf("Process %d is idle.\n", rank);
    }

    MPI_Finalize();
    return 0;
}

