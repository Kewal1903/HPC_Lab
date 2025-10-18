#include <stdio.h>
#include <omp.h>

int main() {
    int a = 20, b = 5;
    int add, sub, mul;
    float div;
    #pragma omp parallel sections
    {
        #pragma omp section
        add = a + b;

        #pragma omp section
        sub = a - b;

        #pragma omp section
        mul = a * b;
        
        #pragma omp section
        div = (float)a / b;
    }
    printf("Add = %d\n", add);
    printf("Sub = %d\n", sub);
    printf("Mul = %d\n", mul);
    printf("Div = %.2f\n", div);
    return 0;
}

