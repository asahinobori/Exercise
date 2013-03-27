/*
This function returns the nth Fabonacci number
*/
#include <stdio.h>
#include <stdlib.h>
int fibonacci(int num);
int power(int num);

int base[] = {1, 1, 0};

int fibonacci(int num) {
    if (num == 1 || num == 2)
        return num - 1;
    else 
       return(power(num));
}

int power(int num) {
    int i,j;
    int matrix[] = {1, 1, 0};
    int temp[3];
    for (i = 0; i < num - 1; i++) {
    temp[0] = matrix[0] * base[0] + matrix[1] * base[1];
    temp[1] = matrix[0] * base[1] + matrix[1] * base[2];
    temp[2] = matrix[1] * base[1] + matrix[2] * base[2];
    for (j = 0; j < 3; j++)
        matrix[j] = temp[j];
}
    return matrix[0]; 
}
    
void main(int argc, char *argv[]) {
    int nfibo;
    nfibo = fibonacci(atoi(argv[1]));
    printf("%d\n", nfibo);
} 
