#include <stdio.h>
int main() {
    int SIZE = 5;
    int A[SIZE][SIZE], B[SIZE][SIZE];
    int i, j, row_max, row_min;
    printf("Enter elements of 5x5 matrix A:\n");
    for (i = 0; i < SIZE; i++) {
        for (j = 0; j < SIZE; j++) {
            scanf("%d", &A[i][j]);
        }
    }
    for (i = 0; i < SIZE; i++) {
        row_max = A[i][0];
        row_min = A[i][0];
        for (j = 1; j < SIZE; j++) {
            if (A[i][j] > row_max) {
                row_max = A[i][j];
            }
            if (A[i][j] < row_min) {
                row_min = A[i][j];
            }
        }
        for (j = 0; j < SIZE; j++) {
            if (i == j) {
                B[i][j] = 0;  
            } else if (j < i) {
                B[i][j] = row_max; 
            } else {
                B[i][j] = row_min; 
            }
        }
    }
    printf("\nResultant Matrix B:\n");
    for (i = 0; i < SIZE; i++) {
        for (j = 0; j < SIZE; j++) {
            printf("%d\t", B[i][j]);
        }
        printf("\n");
    }
    return 0;
}

