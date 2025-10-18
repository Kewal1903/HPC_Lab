#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <omp.h>
int main(){
char str[] = "Hello";
int n = strlen(str);
#pragma omp parallel for
for(int i = 0; i < n; i++){
if(isupper(str[i])) str[i] = tolower(str[i]);
else if(islower(str[i])) str[i] = toupper(str[i]);
printf("Thread %d toggled index %d to %c \n", omp_get_thread_num(), i, str[i]);
}
printf("Toggled string : %s \n", str);
return 0;
}
