#include <mpi.h>
#include <stdio.h>

int main(int argc,char* argv[]){
    int rank,size;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    int A[16], row[4], result[16];
    if(rank==0){
        printf("Enter 4x4 matrix:\n");
        for(int i=0;i<16;i++) scanf("%d",&A[i]);
    }

    // --- Multiprocessing Section ---
    MPI_Scatter(A,4,MPI_INT,row,4,MPI_INT,0,MPI_COMM_WORLD);

    for(int i=0;i<4;i++) row[i]+=rank+1;

    MPI_Gather(row,4,MPI_INT,result,4,MPI_INT,0,MPI_COMM_WORLD);

    if(rank==0){
        printf("Output matrix:\n");
        for(int i=0;i<16;i++){
            printf("%d ",result[i]);
            if((i+1)%4==0) printf("\n");
        }
    }

    MPI_Finalize();
    return 0;
}
