// generate the opcode for an addi instruction

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// return the MIPS opcode for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    uint32_t result = 0;
    //001000ssssstttttIIIIIIIIIIIIIIII

    //001000
    uint32_t first_6 = 0x8;
    result = first_6 << 26;
    
    //sssss
    uint32_t second = s;
    second = second << 21;
    result = result | second;

    //tttttt
    uint32_t third = t;
    third = third << 16;
    result = result | third;

    //IIIIIIIIIIIIIIII
    uint16_t last = i;
    result = result | last;
        
    return result; // REPLACE WITH YOUR CODE

}
