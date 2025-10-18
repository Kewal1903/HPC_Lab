#include <mpi.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {
    int rank, size;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    char s1[100], s2[100], part1[100], part2[100], result[200], final[200];
    int len;

    if(rank==0) {
        printf("Enter string1: ");
        scanf("%s", s1);
        printf("Enter string2: ");
        scanf("%s", s2);
        len = strlen(s1);

        // --- Multiprocessing Section ---
        MPI_Bcast(&len,1,MPI_INT,0,MPI_COMM_WORLD);
    } else {
        MPI_Bcast(&len,1,MPI_INT,0,MPI_COMM_WORLD);
    }

    int chunk = len/size;
    MPI_Scatter(s1,chunk,MPI_CHAR,part1,chunk,MPI_CHAR,0,MPI_COMM_WORLD);
    MPI_Scatter(s2,chunk,MPI_CHAR,part2,chunk,MPI_CHAR,0,MPI_COMM_WORLD);

    char merged[200];
    for(int i=0;i<chunk;i++) {
        merged[2*i]=part1[i];
        merged[2*i+1]=part2[i];
    }

    MPI_Gather(merged,2*chunk,MPI_CHAR,result,2*chunk,MPI_CHAR,0,MPI_COMM_WORLD);

    if(rank==0) {
        result[2*len]='\0';
        printf("Resultant String: %s\n", result);
    }

    MPI_Finalize();
    return 0;
}
