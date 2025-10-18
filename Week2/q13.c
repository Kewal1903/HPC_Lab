#include <stdio.h>
#include <omp.h>

int reverse_digits(int num){
int rev = 0; 
while(num != 0){
rev = rev * 10 + num % 10;
num /= 10;
}
return rev;
}

int main(){
int input[9] = {18, 523, 301, 1234, 2, 14, 108, 150, 1928};
int output[9];

#pragma omp parallel for
for(int i = 0; i < 9; i++){
output[i] = reverse_digits(input[i]);
printf("Thread %d reversed %d -> %d \n", omp_get_thread_num(), input[i], output[i]);
}
printf("Reversed array: \n");
for(int i = 0; i < 9; i++) printf("%d", output[i]);
printf("\n");
return 0;
}
