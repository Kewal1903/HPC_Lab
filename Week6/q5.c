#include <mpi.h>
#include <stdio.h>

int main(int argc,char* argv[]){
    int rank,size,err;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    MPI_Errhandler_set(MPI_COMM_WORLD,MPI_ERRORS_RETURN);

    int val;
    err = MPI_Bcast(&val,1,MPI_INT,5,MPI_COMM_WORLD); // root=5 (error if size<=5)

    if(err!=MPI_SUCCESS){
        char errstr[MPI_MAX_ERROR_STRING]; int sz;
        MPI_Error_string(err,errstr,&sz);
        printf("Rank %d: Error - %s\n",rank,errstr);
    }

    MPI_Finalize();
    return 0;
}
