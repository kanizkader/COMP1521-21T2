//Lab 2
//z5363412
//Convert an 8 digit Packed BCD Value to an Integer

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BCD_DIGITS 8

uint32_t packed_bcd(uint32_t packed_bcd);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= 0 && l <= UINT32_MAX);
        uint32_t packed_bcd_value = l;

        printf("%lu\n", (unsigned long)packed_bcd(packed_bcd_value));
    }

    return 0;
}

// given a packed BCD encoded value between 0 .. 99999999
// return the corresponding integer
uint32_t packed_bcd(uint32_t packed_bcd_value) {

    // PUT YOUR CODE HERE
    int result_tens;
    result_tens = packed_bcd_value >> 4;
    int result_ones;
    result_ones = packed_bcd_value & 0x0F;
    int final;
    final = (result_tens * 10) + result_ones;
    if (final <= 0 || final >= 99999999) {
        final = final % 100000000;
    }
    return final;
    
}
