#include <stdio.h>
#include <omp.h>
int main() {
    int M = 5, N = 5;
    int A[M][N];
    int B[M][N];
    int D[M][N];
    printf("Enter matrix A (%dx%d):\n", M, N);
    for(int i=0; i<M; i++)
        for(int j=0; j<N; j++)
            scanf("%d", &A[i][j]);
    #pragma omp parallel for collapse(2)
    for(int i=0; i<M; i++) {
        for(int j=0; j<N; j++) {
            if(i == 0 || i == M-1 || j == 0 || j == N-1) {
                B[i][j] = A[i][j]; 
            } else {
                B[i][j] = ~A[i][j]; 
            }
        }
    }
    #pragma omp parallel for collapse(2)
    for(int i=0; i<M; i++)
        for(int j=0; j<N; j++)
            D[i][j] = A[i][j] + B[i][j];

    printf("Matrix B:\n");
    for(int i=0; i<M; i++) {
        for(int j=0; j<N; j++)
            printf("%d ", B[i][j]);
        printf("\n");
    }

    printf("Matrix D:\n");
    for(int i=0; i<M; i++) {
        for(int j=0; j<N; j++)
            printf("%d ", D[i][j]);
        printf("\n");
    }

    return 0;
}

