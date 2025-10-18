#include <mpi.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    int rank, size, M, N;
    MPI_Init(&argc, &argv); 
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    M = 2; // columns
    N = size; // rows = processes
    int arr[100];
    int subarr[100];
    int i;

    if(rank == 0) {
        int matrix[100], k=0;
        printf("Enter %d elements:\n", M*N);
        for(i=0;i<M*N;i++) scanf("%d",&matrix[i]);

        // --- Multiprocessing Section ---
        MPI_Scatter(matrix, M, MPI_INT, subarr, M, MPI_INT, 0, MPI_COMM_WORLD);
    } else {
        MPI_Scatter(NULL, M, MPI_INT, subarr, M, MPI_INT, 0, MPI_COMM_WORLD);
    }

    int local_sum=0;
    for(i=0;i<M;i++) local_sum += subarr[i];
    double local_avg = (double)local_sum/M;

    double total_avg;
    // --- Multiprocessing Section ---
    MPI_Reduce(&local_avg, &total_avg, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if(rank==0) {
        total_avg /= N;
        printf("Total Average = %f\n", total_avg);
    }

    MPI_Finalize();
    return 0;
}
