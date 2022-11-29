#include <sys/types.h>

#include <sys/stat.h>

#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main (int argc, char *argv[]) {    
    
    char *path = getenv("PATH");
    if(path) {
        printf("1\n");
    } else {
        printf("0\n");
    }  

    
   
    return 0;
}

