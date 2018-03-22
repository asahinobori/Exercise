#include <stdio.h>

int main(void) {
    unsigned int testUIntSize = 0;
    unsigned int in = 0;
    unsigned char out;
    testUIntSize = sizeof(testUIntSize);
    printf("test endian:\n");
    if (testUIntSize == 2) {
        // 16bits for unsigned int
        in = 0x0201;
    } else if (testUIntSize == 4) {
        // 32bits for unsigned int
        in = 0x04030201;
    } else if (testUIntSize == 8) {
        // 64bits for unsigned int
        in = 0x0807060504030201;
    } else {
        printf("Unsigned Int is not 16 or 32 or 64bits\n");
        return -1;
    }

    out = *((unsigned char*)&in);

    printf("unsigned int is %d bytes, input data is 0x%x, output data(first byte) is 0x%x\n", testUIntSize, in, out);

    if (0x01 == out) {
        printf("result: little endian\n");
    } else {
        printf("result: big endian\n");
    }
    return 0;
}
