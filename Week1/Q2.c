#include <stdio.h>

int main(){
float A, B;
printf("Enter value for A: ");
scanf("%f", &A);
printf("Enter value for B: ");
scanf("%f", &B);

printf("A + B = %.2f \n", A + B);
printf("A - B = %.2f \n", A - B);
printf("A * B = %.2f \n", A * B);
if(B != 0) printf("A / B = %.2f \n", A / B);
else printf("A / B is undefined (Zero division error). \n");
return 0;
}
