#include <stdio.h>
#include <time.h>
main(){
    int i;
    int n = 100000;
    srand((int)time(0));
    FILE *f = fopen("Data", "w");
    for (i = 0; i < 100000; i++)
        fprintf(f, "%d\n", rand());
}


