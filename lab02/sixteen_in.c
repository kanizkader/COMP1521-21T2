//Lab 2
//z5363412
// Convert string of binary digits to 16-bit signed integer

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define N_BITS 16

int16_t sixteen_in(char *bits);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        printf("%d\n", sixteen_in(argv[arg]));
    }

    return 0;
}

//
// given a string of binary digits ('1' and '0')
// return the corresponding signed 16 bit integer
//
int16_t sixteen_in(char *bits) {
    // PUT YOUR CODE HERE
    
    uint16_t mask = 1u; //0000 0000 0000 0001
    uint16_t result = 0;//0000000000000000
    int i = 0;
    while (i <= N_BITS) {
        if (bits[i] == '1') {
            //if 1, make new mask which takes care of the next 1 in line
            uint16_t new_mask = mask << (15 - i);
            result = result | new_mask;
        }        
               
        i++;
    }
    
    //sign
    if (bits[0] == 1) {
        result = -result;
    }
    
    return result;
}

