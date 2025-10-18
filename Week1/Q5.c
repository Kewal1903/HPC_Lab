#include <stdio.h>
#include <string.h>

int main() {
    char S1[100], S2[100], result[200];
    printf("Enter string S1: ");
    scanf("%s", S1);
    printf("Enter string S2: ");
    scanf("%s", S2);
    int len1 = strlen(S1);
    int len2 = strlen(S2);

    if (len1 != len2) {
        printf("Strings are not of the same length.\n");
        return 1;
    }
    int k = 0;
    for (int i = 0; i < len1; i++) {
        result[k++] = S1[i];
        result[k++] = S2[i];
    }
    result[k] = '\0';  
    printf("Resultant String: %s\n", result);
    return 0;
}

