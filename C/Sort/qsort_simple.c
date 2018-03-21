#include<stdio.h>
#include <time.h>
/*最简单但效率不高的快速排序算法*/

int a[100000];

void qsort(int v[], int left, int right) {
    int i, last;
    void swap(int v[], int i, int j);

    if(left >= right)
        return;

    last = left;
    for(i = left+1; i <= right; i++)
        if(v[i] < v[left])
            swap(v, ++last, i);
    swap(v, last, left);
    
    qsort(v, left, last-1);
    qsort(v, last+1, right);
}

void swap(int v[], int i, int j) {
    int temp;
    temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

/*这个main函数是用来测试上面的qsort算法的*/
int main(void) {
    int i, n;
    n = 100000;
    FILE *fp = fopen("Data", "r");
    for (i = 0; i < n; i++)
        fscanf(fp, "%d\n", &a[i]);
    int c1 = clock();
    qsort(a, 0, n - 1);
    int c2 = clock();
    printf("time=%d\n", c2-c1);
    FILE *f = fopen("Data_Sorted", "w");
    for (i = 0; i < n; i++)
        fprintf(f, "%d\n", a[i]);
    fclose(f);
    return 0;
}    
