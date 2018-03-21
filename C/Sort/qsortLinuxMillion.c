#include <stdio.h>
#include <stdlib.h>

int cmp(const void* a, const void* b) {
    unsigned long num1 = *(unsigned int*)a;
    unsigned long num2 = *(unsigned int*)b;
    long int diff = num1 - num2;
    if (diff > 0) {
        return 1;
    } else if (diff == 0) {
        return 0;
    } else {
        return -1;
    }
}

int main(void) {
    unsigned int a[1000000] = { 0 };
    int i;
    FILE* fp = fopen("./ra", "r");
    FILE* fp2 = fopen("./raSorted", "w");
    if (NULL == fp) {
        printf("open ra file error\n");
        return -1;
    }
    for (i = 0; i < 1000000; i++) {
        fscanf(fp, "%u\n", &a[i]);
    }
    fclose(fp);
    printf("data load finish, start sort\n");
    qsort(a, 1000000, sizeof(a[0]), cmp);
    printf("data sort finish");
    printf("the No.500000 max is %u\n", a[499999]);
    for (i = 0; i < 1000000; i++) {
        fprintf(fp2, "%u\n", a[i]);
    }
    fclose(fp2);
    printf("data update to raSorted\n");
    return 0;
}
