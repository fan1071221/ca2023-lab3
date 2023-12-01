#include <stdio.h>
#include <stdint.h>

uint16_t clz(uint64_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555 );
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}
int main() {
    *((volatile int *) (4)) = clz(0xf1ac00000123); //16
    *((volatile int *) (8)) = clz(0x1ac12123489); //23
    *((volatile int *) (12)) = clz(0x100032498); //31
    return 0;
}
