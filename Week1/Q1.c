#include <stdio.h>
int reverseNumber(int num){
int reversed = 0;
while(num > 0){
reversed = (reversed * 10) + (num % 10);
num = num / 10;
}
return reversed;
}

int main(){
int input[9] = {18, 523, 301, 1234, 2, 14, 108, 150, 1928};
int output[9];
for(int i = 0; i < 9; i++){
output[i] = reverseNumber(input[i]);
}
printf("Reversed array is: \n");
for(int i = 0; i < 9; i++){
printf("%d, ", output[i]);
}
}
