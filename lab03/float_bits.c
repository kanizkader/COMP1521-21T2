// Extract the 3 parts of a float using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
float_components_t float_bits(uint32_t f) {
    // PUT YOUR CODE HERE
    float_components_t num;
     
    //Sign
    int result_sign;
    result_sign = f >> 31;
    num.sign = result_sign;    
         
           
    //Exponent
    //int result_exponent;
    uint32_t exp = 0;
    
    uint32_t mask_1 = 255;
    uint32_t mask = mask_1 << 23;
    exp = f & mask;
    exp = exp >> 23;
    num.exponent = exp;
    
    //ANOTHER WAY TO DO IT: (f >> 23) & 0xFF
         
    /*int i = 0;
    int count = -1;
    while (i <= 7) {
        if (result_exponent == 1) {
            int sum = 0; 
            sum = sum + 2^count;
            count--;
        }
        i++;
    }    
    uint32_t exponent {
        int exponent;
        result = f + 127;
        return exponent;
    }*/   
    
    //Fraction
    uint32_t frac = 0;
    uint32_t mask00 = 8388607;
    frac = f & mask00;
    num.fraction = frac;
    
    //ANOTHER WAY TO DO IT: f & 0x7FFFFF
    return num;
    
     
    /*uint32_t fraction {
        int fraction;
        fraction = (f/(2^exponent)) - 1;
        return fraction;
    }*/
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    // PUT YOUR CODE HERE
    //NaN
    if (f.exponent == 255 && f.fraction > 0) {
    //exp == 255 fract > 0
        return 1;
    }
    else {
        return 0;
    }  
    
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    if (f.exponent == 255 && f.fraction == 0 && f.sign == 0) {
        return 1;
    }
    else {
        return 0;
    }   
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    // PUT YOUR CODE HERE
    if (f.exponent == 255 && f.fraction == 0 && f.sign == 1) {
        return 1;
    }
    else {
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    // PUT YOUR CODE HERE
    if (f.fraction == 0 && f.exponent == 0) {
        return 1;
    }
    else {
        return 0;
    }
    
}
