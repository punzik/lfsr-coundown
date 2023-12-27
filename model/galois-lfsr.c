#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// #define DEBUG

typedef struct {
    int n;
    uint64_t poly;
} lfsr_tap_t;

lfsr_tap_t taps[] = {
    {3, 0x6},
    {4, 0xc},
    {5, 0x14},
    {6, 0x30},
    {7, 0x60},
    {8, 0xb8},
    {9, 0x110},
    {10, 0x240},
    {11, 0x500},
    {12, 0x829},
    {13, 0x100d},
    {14, 0x2015},
    {15, 0x6000},
    {16, 0xd008},
    {17, 0x12000},
    {18, 0x20400},
    {19, 0x40023},
    {20, 0x90000},
    {21, 0x140000},
    {22, 0x300000},
    {23, 0x420000},
    {24, 0xe10000},
    {25, 0x1200000},
    {26, 0x2000023},
    {27, 0x4000013},
    {28, 0x9000000},
    {29, 0x14000000},
    {30, 0x20000029},
    {31, 0x48000000},
    {32, 0x80200003},
    {33, 0x100080000},
    {34, 0x204000003},
    {35, 0x500000000},
    {36, 0x801000000},
    {37, 0x100000001f},
    {38, 0x2000000031},
    {39, 0x4400000000},
    {40, 0xa000140000},
    {41, 0x12000000000},
    {42, 0x300000c0000},
    {43, 0x63000000000},
    {44, 0xc0000030000},
    {45, 0x1b0000000000},
    {46, 0x300003000000},
    {47, 0x420000000000},
    {48, 0xc00000180000},
    {49, 0x1008000000000},
    {50, 0x3000000c00000},
    {51, 0x6000c00000000},
    {52, 0x9000000000000},
    {53, 0x18003000000000},
    {54, 0x30000000030000},
    {55, 0x40000040000000},
    {56, 0xc0000600000000},
    {57, 0x102000000000000},
    {58, 0x200004000000000},
    {59, 0x600003000000000},
    {60, 0xc00000000000000},
    {61, 0x1800300000000000},
    {62, 0x3000000000000030},
    {63, 0x6000000000000000},
    {64, 0xd800000000000000}};

const int taps_len = sizeof(taps)/sizeof(lfsr_tap_t);

int main(int argc, char **argv)
{
    if (argc != 2) {
	printf("Usage: %s COUNT_TO\n", argv[0]);
	return -1;
    }

    uint64_t count_to = strtoul(argv[1], NULL, 0);
    uint64_t sreg = 0;
    uint64_t poly, msb = 0;

    for (int n = 0; n < taps_len; n ++) {
	uint64_t max = (1ul << taps[n].n) - 1;
	if (count_to < max) {
	    msb = 1ul << (taps[n].n-1);
	    poly = taps[n].poly;
	    break;
	}
    }

    if (!msb) {
	printf("LFSR for %li not found\n", count_to);
	return -1;
    }

    printf("Count to: %lu\n", count_to);
    printf("Polynome: 0x%lx\n", poly);

    for (; count_to; count_to --) {
#ifdef DEBUG
	printf("n: %lu, reg: %.16lx\n", count_to, sreg);
#endif
	sreg = (sreg & 1) ? (sreg >> 1) | msb : ((sreg >> 1) ^ poly) & ~msb;
    }

    printf("Stop at: 0x%lx\n", sreg);
    return 0;
}
