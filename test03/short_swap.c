// Swap bytes of a short

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

// given uint16_t value return the value with its bytes swapped
uint16_t short_swap(uint16_t value) {
    // PUT YOUR CODE HERE
    
    uint16_t result = 0; 
    uint16_t byte_1 = value >> 8;
    uint16_t byte_2 = value << 8;
    result = (byte_1 | byte_2) | result;  
    return result;
}
