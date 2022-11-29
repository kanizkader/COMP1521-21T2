#include "float_exp.h"

// given the 32 bits of a float return the exponent
uint32_t float_exp(uint32_t f) {
    //extract exponent
    uint32_t exp = 0;
    
    uint32_t mask_1 = 255;
    uint32_t mask = mask_1 << 23;
    exp = f & mask;
    exp = exp >> 23;
    
    
    return exp; // REPLACE ME WITH YOUR CODE
}
