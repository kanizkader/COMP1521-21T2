//Lab 1
//By z5363412
//Calculating the Fibonacci Sequence The (Not So) Fast Way

#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 46

int fib(int n) {
    if(n == 0) {
        return 0;
    }
	
    else if(n == 1) {
        return 1;
    }
       
    else {
        return fib(n-1) + fib(n-2);
    }
}

int main(void) {
    //int already_computed[SERIES_MAX + 1] = { 0, 1 };
	//(void) already_computed; // keep the compiler quiet, should be removed
    int n = 0;
    while (scanf("%d",&n) == 1) {    
        printf("%d\n", fib(n));
    }  
    return 0;
}
