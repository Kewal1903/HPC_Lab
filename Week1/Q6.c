#include <stdio.h>
int main() {
    int m, n;
    printf("Enter number of rows (m): ");
    scanf("%d", &m);
    printf("Enter number of columns (n): ");
    scanf("%d", &n);
    int matrix[m][n];
    int vector[n];
    int result[m];
    printf("Enter matrix elements (%dx%d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%d", &matrix[i][j]);
        }
    }
    printf("Enter vector elements (%d):\n", n);
    for (int i = 0; i < n; i++) {
        scanf("%d", &vector[i]);
    }
    for (int i = 0; i < m; i++) {
        result[i] = 0;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            result[i] += matrix[i][j] * vector[j];
        }
    }
    printf("Resultant vector:\n");
    for (int i = 0; i < m; i++) {
        printf("%d\n", result[i]);
    }
    return 0;
}

