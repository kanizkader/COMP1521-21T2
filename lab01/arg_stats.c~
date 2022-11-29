//Lab 1
//By z5363412
//Statistical Analysis of Command Line Arguments

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	//(void) argc, (void) argv; // keep the compiler quiet, should be removed
	
	if (argv[1] == NULL) {
	    printf("%s NUMBER [NUMBER ...]\n", argv[0]);
	}
	
	//MINIMUM
	int min = atoi(argv[1]);
	int i = 1;
	while (i < argc) {
	    if (atoi(argv[i]) < min) {
	        min = atoi(argv[i]);
	    }	
	    i++;
	}
	printf("MIN:  %d\n",min);
	
	//MAXIMUM
	int max = atoi(argv[1]);
	int j = 1;
	while (j < argc) {
	    if (atoi(argv[j]) > max) {
	        max = atoi(argv[j]);
	    }	
	    j++;
	}
	printf("MAX:  %d\n",max);
	
	//SUM
	int k = 1;
	int sum = 0;
	while (k < argc) {
	    sum += atoi(argv[k]);
	    k++;
	}
	printf("SUM:  %d\n",sum);
	
	//PRODUCT
	int l = 1;
	int prod = 1;
	while (l < argc) {
	    prod *= atoi(argv[l]);
	    l++;
	}	
	printf("PROD: %d\n",prod);
	
	//MEAN
	int mean = 0;
	mean = sum/(argc - 1);
	printf("MEAN: %d\n",mean);
	
	return 0;
}
