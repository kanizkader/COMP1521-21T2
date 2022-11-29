// swap pairs of bits of a 64-bit value, using bitwise operators

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return value with pairs of bits swapped
uint64_t bit_swap(uint64_t value) {
    // PUT YOUR CODE HERE
    uint64_t result = 0;
    uint64_t final = 0;
    int i = 0;
    while (i <= 32) {
                
        uint64_t bit_1 = value >> 1;
        uint64_t bit_2 = value << 1;
        result = (bit_1 | bit_2) | result;
        //result = result << 2;
        final = final << 2;   
        final = final | result;
                       
           
        value = value >> 2;
        
        i++;
    }
    return final;
}
