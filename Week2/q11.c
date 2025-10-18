#include <stdio.h>
#include <omp.h>

int main(){
int size = 5;
int A[size][size];
int B[size][size];
printf("Enter matrix A (5x5): \n");
for(int i = 0; i < size; i++)
for(int j = 0; j < size; j++)
scanf("%d", &A[i][j]);

#pragma omp parallel for
for(int i = 0; i < size; i++){
int max_val = A[i][0], min_val = A[i][0];
for(int j = 1; j < size; j++){
if(A[i][j] > max_val) max_val = A[i][j];
if(A[i][j] < min_val) min_val = A[i][j];
}
for(int j = 0; j < size; j++){
if(i == j) B[i][j] = 0;
else if (i > j) B[i][j] = max_val;
else B[i][j] = min_val;
}
}
printf("Matrix B: \n");
for(int i = 0; i < size; i++){
for(int j = 0; j < size; j++){
printf("%d ", B[i][j]);
}
printf("\n");
}
return 0;
}
