#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#include "add.h"

// return the MIPS opcode for add $d, $s, $t
uint32_t make_add(uint32_t d, uint32_t s, uint32_t t) {
    uint32_t result = 0;
    //000000ssssstttttddddd00000100000

    //sssss
    uint32_t second = s;
    second = second << 21;
    result = result | second;

    //tttttt
    uint32_t third = t;
    third = third << 16;
    result = result | third;

    //ddddd
    uint32_t fourth = d;
    fourth = fourth << 11;
    result = result | fourth;

    //100000
    uint32_t last = 1u;
    last = last << 5;
    result = result | last;


    return result; // REPLACE WITH YOUR CODE

}
