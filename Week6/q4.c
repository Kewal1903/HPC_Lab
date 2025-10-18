#include <mpi.h>
#include <stdio.h>

int main(int argc,char* argv[]){
    int rank,size;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    int matrix[9],subarr[3],element,count=0,total;

    if(rank==0){
        printf("Enter 9 elements of 3x3 matrix:\n");
        for(int i=0;i<9;i++) scanf("%d",&matrix[i]);
        printf("Enter element to search: ");
        scanf("%d",&element);
    }

    // --- Multiprocessing Section ---
    MPI_Bcast(&element,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(matrix,3,MPI_INT,subarr,3,MPI_INT,0,MPI_COMM_WORLD);

    for(int i=0;i<3;i++) if(subarr[i]==element) count++;

    MPI_Reduce(&count,&total,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);

    if(rank==0) printf("Occurrences = %d\n",total);

    MPI_Finalize();
    return 0;
}
