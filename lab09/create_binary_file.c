#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


// places command line into a file
int main(int argc, char *argv[]) {
    
    FILE *stream = fopen(argv[1], "w+");
    if (stream == NULL) {
        perror(argv[1]);
        return 1;
    }
        
    int i = 2;
    while (i < argc) {
        int asc = atoi(argv[i]);
        fputc(asc, stream);
        i++;
    }
    //printf("%d",i);
    fclose(stream);
    return 0;
}    