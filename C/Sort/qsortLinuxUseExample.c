#include <stdlib.h>
#include <stdio.h>

int cmp(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int main(void) {
    int i = 0;
    int num[10] = {4, 7, 9, 2, 6, 8, 1, 3, 5, 10};
    qsort(num, 10, sizeof(num[0]), cmp);
    for (i = 0; i < 10; i++) {
        printf("%d ", num[i]);
    }
    printf("\n");
    return 0;
}
