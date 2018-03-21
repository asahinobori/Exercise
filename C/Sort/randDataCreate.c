/* 创建一百万个随机数据
 * ra是uint32的数据(所以表示成int时注意变成了负数，影响大小判断)
 * raIntP是int32的数据但负数全部取其绝对值
 */
#include <stdio.h>

#define uint32_t unsigned int

unsigned int randFun(void) {
    static uint32_t x = 123456789;
    static uint32_t y = 362436069;
    static uint32_t z = 521288629;
    static uint32_t w = 88675123;
    uint32_t t;
    t = x ^ (x << 11);
    x = y; y = z; z = w;
    return w = w ^ (w >> 19) ^ (t ^ (t >> 8));
}

int main() {
    FILE* fp = NULL;
    FILE* fp2 = NULL;
    fp = fopen("./ra", "w");
    fp2 = fopen("./raIntPositive", "w");
    if (fp == NULL) {
        printf("error open file\n");
        return -1;
    }
    unsigned int ra = 0;
    int raIntP = 0;
    int tmp = 0;
    for (int i = 0; i < 1000000; i++) {
        ra = randFun();
        tmp = (int)ra;
        raIntP = (tmp < 0) ? (tmp * (-1)) : tmp;
        // printf("%u, %d\n", ra raIntP);
        fprintf(fp, "%u\n", ra);
        fprintf(fp2, "%d\n", raIntP);
    }
    fclose(fp);
    fclose(fp2);
}
