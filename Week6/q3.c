#include <mpi.h>
#include <stdio.h>

int factorial(int n){
    int f=1; for(int i=1;i<=n;i++) f*=i;
    return f;
}

int main(int argc,char* argv[]){
    int rank,size,n=5;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    int val=factorial(rank+1);
    int prefix_sum;
    // --- Multiprocessing Section ---
    MPI_Scan(&val,&prefix_sum,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);

    if(rank==size-1) printf("Result = %d\n", prefix_sum);

    MPI_Finalize();
    return 0;
}
