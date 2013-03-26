#include<stdio.h>
//带标记的冒泡排序
int a[100];

void bubble_sort(int d[], int size) {
    int exchange = size - 1;

    while(exchange) {
        int bound = exchange, i;
        exchange = 0;
        for (i = 0; i < bound; i++) {
            if (d[i] > d[i + 1]) {
                int t = d[i];
                d[i] = d[i + 1];
                d[i + 1] = t;

                exchange = i + 1;
            }
        }
    }
}

int main(void) {
    int i, n;
    n = 100; 
    FILE *fp = fopen("Data", "r");
    for (i = 0; i < n; i++) 
        fscanf(fp, "%d\n", &a[i]);
    fclose(fp);
    int cl = clock();
    bubble_sort(a, n);
    int cl1 = clock();
    printf("time=%d\n", cl1-cl);
    FILE *f = fopen("Data_sorted", "w");
    for (i = 0; i < n; i++)
        fprintf(f, "%d\n", a[i]);
    fclose(f);
    return 0;
}
