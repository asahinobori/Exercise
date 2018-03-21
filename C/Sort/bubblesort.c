#include<stdio.h>
//不带标记的冒泡排序(效率比带标记的普遍要低)
int a[100];

void bubbleSort(int arr[], int count)
{
    int i = count, j; 
	int temp; 

	while (i > 0) {
		for (j = 0; j < i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
        i--;
    } 
}

/*测试函数*/
int main(int arc, char* const argv[]) {
    int i, n;
    n = 100; 
    FILE *fp = fopen("Data", "r");
    for (i = 0; i < n; i++) 
        fscanf(fp, "%d\n", &a[i]);
    fclose(fp);
    int cl = clock();
    bubbleSort(a, n);
    int cl1 = clock();
    printf("time=%d\n", cl1-cl);
    FILE *f = fopen("Data_Sorted", "w");
    for (i = 0; i < n; i++)
        fprintf(f, "%d\n", a[i]);
    fclose(f);
    return 0;
}

