#include<stdio.h>
/*比较有效率的快速排序算法*/
int a[100000];

void quicksort(int a[], int l, int h) {
    if (l >= h)
        return; 
    int i, j, key; 
    i = l; j = h; key = a[i];
    while (i < j) {
        while (i < j && a[j] > key)
            j--;
        if (i < j)
            a[i++] = a[j];
        while (i < j && a[i] < key)
            i++;
        if (i < j)
            a[j--] = a[i];
    }
    a[i] = key; 
    if (l < i - 1)
        quicksort(a, l, i - 1);
    if (i + 1 < h)
        quicksort(a, i + 1, h);
}

/*测试函数*/
int main(void) {
    int i, n;
    n = 100000;
    FILE *fp = fopen("Data", "r");
    for (i = 0; i < n; i++) 
        fscanf(fp, "%d\n", &a[i]);
    fclose(fp);
    int cl = clock();
    quicksort(a, 0, n-1);
    int cl1 = clock();
    printf("time=%d\n", cl1-cl);
    FILE *f = fopen("Data_Sorted", "w");
    for (i = 0; i < n; i++)
        fprintf(f, "%d\n", a[i]);
    fclose(f);
    return 0;
}
