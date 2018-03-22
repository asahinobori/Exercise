#include <stdio.h>
#include <stdlib.h>

void myqsort(unsigned int a[], int left, int right) {
    if (left >= right) return;
    int i, j, key;
    i = left; j = right; key = a[left];
    while (i < j) {
        while (i < j && a[j] > key) j--;
        if (i < j) a[i++] = a[j];
        while (i < j && a[i] < key) i++;
        if (i < j) a[j--] = a[i];   
    }
    a[i] = key;
    if (left < i-1) myqsort(a, left, i-1);
    if (right > i+1) myqsort(a, i+1, right);
}

// int cmp(const void* a, const void* b) {
//     unsigned long num1 = *(unsigned int*)a;
//     unsigned long num2 = *(unsigned int*)b;
//     long int diff = num1 - num2;
//     if (diff > 0) {
//         return 1;
//     } else if (diff == 0) {
//         return 0;
//     } else {
//         return -1;
//     }
// }

int main(void) {
    unsigned int a[1000000] = { 0 };
    int i;
    FILE* fp = fopen("./Data", "r");
    FILE* fp2 = fopen("./Data_Sorted", "w");
    if (NULL == fp) {
        printf("open Data file error\n");
        return -1;
    }
    for (i = 0; i < 1000000; i++) {
        fscanf(fp, "%u\n", &a[i]);
    }
    fclose(fp);
    printf("data load finish, start sort\n");
    // qsort(a, 1000000, sizeof(a[0]), cmp);
    myqsort(a, 0, 1000000-1);
    printf("data sort finish");
    printf("the No.500000 max is %u\n", a[499999]);
    for (i = 0; i < 1000000; i++) {
        fprintf(fp2, "%u\n", a[i]);
    }
    fclose(fp2);
    printf("data update to Data_Sorted\n");
    return 0;
}
