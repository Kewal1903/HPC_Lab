#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(int *A, int *B, int *C, int N){
int idx = threadIdx.x;
if(idx < N){
C[idx] = A[idx] + B[idx];
}
}

int main(){
int N = 1024;
int *A, *B, *C;
int *d_A, *d_B, *d_C;

A = (int *)malloc(N * sizeof(int));
B = (int *)malloc(N * sizeof(int));
C = (int *)malloc(N * sizeof(int));

for(int i = 0; i < N; i++){
A[i] = i;
B[i] = i * 2;
}

cudaMalloc(&d_A, N * sizeof(int));
cudaMalloc(&d_B, N * sizeof(int));
cudaMalloc(&d_C, N * sizeof(int));

cudaMemcpy(d_A, A, N * sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(d_B, B, N * sizeof(int), cudaMemcpyHostToDevice);

vectorAdd<<<1, N>>>(d_A, d_B, d_C, N);

cudaMemcpy(C, d_C, N * sizeof(int), cudaMemcpyDeviceToHost);
for(int i = 0; i < N; i++){
printf("%d + %d = %d\n", A[i], B[i], C[i]);
}

free(A);
free(B);
free(C);
cudaFree(d_A);
cudaFree(d_B);
cudaFree(d_C);

return 0;
}
