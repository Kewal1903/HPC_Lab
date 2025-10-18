#include <stdio.h>
#include <omp.h>

int parallelSearch(int arr[], int n, int key) {
    int index = -1;

    #pragma omp parallel for
    for (int i = 0; i < n; i++) {
        if (arr[i] == key) {
            #pragma omp critical
            {
                if (index == -1 || i < index)
                    index = i;
            }
        }
    }
    return index;
}

int main() {
    int arr[] = {5, 3, 7, 1, 4, 9};
    int n = sizeof(arr)/sizeof(arr[0]);
    int key = 4;

    int result = parallelSearch(arr, n, key);
    if (result != -1)
        printf("Element found at index: %d\n", result);
    else
        printf("Element not found\n");

    return 0;
}

