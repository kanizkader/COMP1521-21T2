//Lab 1
//By z5363412
//(Dis)Proving the Collatz Conjecture

#include <stdio.h>
#include <stdlib.h>

int recur(int i);
int recur(int i) {
    printf("%d\n", i);
	int result = 0;
	if (i == 1) {
         return 0;
    }
    //EVEN
    else if (i % 2 == 0) {
        result = i/2;
    }
    //ODD
    else if (i % 2 != 0) {
        result = 3 * i + 1;
    }
        	    
	recur(result);
	return result;
}
int main(int argc, char **argv)
{
	//(void) argc, (void) argv; // keep the compiler quiet, should be removed
	
	if (argv[1] == NULL) {
	    printf("Usage: %s NUMBER\n", argv[0]);
	}
	
	recur(atoi(argv[1]));
	return 0;
}


