#include <stdio.h>
#include <time.h>

#define N 1000000
int main(){
    int i;
    srand((int)time(0));
    FILE *f = fopen("Data", "w");
    for (i = 0; i < N; i++)
        fprintf(f, "%d\n", rand());
    return 0;
}


