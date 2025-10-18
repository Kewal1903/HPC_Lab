#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    char str[] = "HeLLO";

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int len = strlen(str);

    if (rank < len) {
        char ch = str[rank];
        if (isupper(ch))
            str[rank] = tolower(ch);
        else if (islower(ch))
            str[rank] = toupper(ch);

        printf("Process %d toggled character to '%c'\n", rank, str[rank]);
    }

    MPI_Finalize();
    return 0;
}

