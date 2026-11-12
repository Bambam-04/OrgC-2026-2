#include <stdio.h>

#define MAX 5

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

int main(void)
{
    int arr[MAX] = {10, 20, 15, -5, -10};
    int n = 5;
    int i;

    printf("Máximo:    %d\n", maximo(arr, n));
    printf("Mínimo:    %d\n", minimo(arr, n));
    printf("Sumatoria: %d\n", sumatoria(arr, n));

    return 0;
}