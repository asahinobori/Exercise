/* 创建一百万个随机数据 */
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
    fp = fopen("./ra", "w");
    if (fp == NULL) {
        printf("error open file\n");
        return -1;
    }
    unsigned int ra = 0;
    for (int i = 0; i < 1000000; i++) {
        ra = randFun();
        // printf("%u\n", ra);
        fprintf(fp, "%u\n", ra);
    }
    fclose(fp);
}
