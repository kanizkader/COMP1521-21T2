#include "bit_rotate.h"

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    /*int result;
    uint16_t mask = 1u;
    result = (bits & mask) << 15; 
    
    int result2 = (bits & (mask << 1) << 14); */
    if (n_rotations == 0) {
        return bits;    
    }
    
    int i = 1;
    uint16_t final = bits;
    
    while (i <= n_rotations) {
        uint16_t result = final >> 1;
        uint16_t change = final << 15;
        final = result | change;
        i++;
    }  
    
    
    return final; //REPLACE ME WITH YOUR CODE
}
