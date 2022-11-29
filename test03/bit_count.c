// count bits in a uint64_t

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return how many 1 bits value contains
int bit_count(uint64_t value) {
    // PUT YOUR CODE HERE
    uint64_t mask = 1u;
    int count = 0;
    int i = 64;    
    while (i >= 0) {
        if ((value & mask) == 1) {
            count++;    
        }
                
        value = value >> 1;
        i--;
    }
    
    return count;
}
