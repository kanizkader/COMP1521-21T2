//Lab 1
//By z5363412
//Pretty Print Command Line Arguments
#include <stdio.h>

int main(int argc, char **argv) {
	//(void) argc, (void) argv; // keep the compiler quiet, should be removed
	
	printf("Program name: %s\n", argv[0]);
	
	//Count no. of arguments
	//int a = 0;	
	int counter = 0;
	while (counter < argc) {
	    counter++;	    
	}
		
	int i = 1;
	//If there are no arguments
	if (argv[1] == NULL) {
		printf("There are no other arguments\n");
	}
	//If there are arguments
	else {
	    counter--;
	    printf("There are %d arguments:\n", counter);
	    while (i < argc) {    	
	    	printf("	Argument %d is \"%s\"\n", i, argv[i]);           
            i++;   
	    }
	}
	
	return 0;
}
