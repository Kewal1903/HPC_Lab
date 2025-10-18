#include <stdio.h>
#include <omp.h>
#include <math.h>

int is_prime(int n){
if(n < 2) return 0;
for(int i = 2; i < sqrt(n); i++){
if(n % i == 0) return 0;
}
return 1;
}

int main(){
int start = 10, end = 50;
#pragma omp parallel for
for(int num = start; num <= end; num++){
if(is_prime(num)){
printf("Thread %d found prime: %d\n", omp_get_thread_num(), num);
}
}
return 0;
}
