// COMP1521 21T2 ... final exam, question 1

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BITS 8

void
and (bool x[BITS], bool y[BITS], bool result[BITS])
{
	// TODO
	char *buffer = malloc((BITS) * sizeof(char));
	char *buffer2 = malloc((BITS) * sizeof(char));
	int i = 0;
	
	while (i < BITS) {
	    if (x[i] == true) {	        
	        buffer[i] = 1;
	    }
	    else {
	        buffer[i] = 0;
	    }
	        
	    if (y[i] == true) {	        
	        buffer2[i] = 1;
	    }	
	    else {
	        buffer2[i] = 0;
	    }
	    
	    if ((buffer[i] == 1) && (buffer2[i] == 1)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 1)) {
	        result[i] = 0;
	    }
	    else if ((buffer[i] == 1) && (buffer2[i] == 0)) {
	        result[i] = 0;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 0)) {
	        result[i] = 0;
	    }
	    i++;
	    
	}
	
	
	
}

void
or (bool x[BITS], bool y[BITS], bool result[BITS])
{
	// TODO
	char *buffer = malloc((BITS) * sizeof(char));
	char *buffer2 = malloc((BITS) * sizeof(char));
	int i = 0;
	
	while (i < BITS) {
	    if (x[i] == true) {	        
	        buffer[i] = 1;
	    }
	    else {
	        buffer[i] = 0;
	    }
	        
	    if (y[i] == true) {	        
	        buffer2[i] = 1;
	    }	
	    else {
	        buffer2[i] = 0;
	    }
	    
	    if ((buffer[i] == 1) && (buffer2[i] == 1)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 1)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 1) && (buffer2[i] == 0)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 0)) {
	        result[i] = 0;
	    }
	    i++;
	    
	}
}

void
xor (bool x[BITS], bool y[BITS], bool result[BITS])
{
	// TODO
	char *buffer = malloc((BITS) * sizeof(char));
	char *buffer2 = malloc((BITS) * sizeof(char));
	int i = 0;
	
	while (i < BITS) {
	    if (x[i] == true) {	        
	        buffer[i] = 1;
	    }
	    else {
	        buffer[i] = 0;
	    }
	        
	    if (y[i] == true) {	        
	        buffer2[i] = 1;
	    }	
	    else {
	        buffer2[i] = 0;
	    }
	    
	    if ((buffer[i] == 1) && (buffer2[i] == 1)) {
	        result[i] = 0;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 1)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 1) && (buffer2[i] == 0)) {
	        result[i] = 1;
	    }
	    else if ((buffer[i] == 0) && (buffer2[i] == 0)) {
	        result[i] = 0;
	    }
	    i++;
	    
	}
}

void
not (bool x[BITS], bool result[BITS])
{
	// TODO
	char *buffer = malloc((BITS) * sizeof(char));
	
	int i = 0;
	
	while (i < BITS) {
	    if (x[i] == true) {	        
	        buffer[i] = 1;
	    }
	    else {
	        buffer[i] = 0;
	    }	            
	    
	    if (buffer[i] == 1) {
	        result[i] = 0;
	    }
	    else if (buffer[i] == 0) {
	        result[i] = 1;
	    }
	    
	    i++;
	    
	}
	
}
