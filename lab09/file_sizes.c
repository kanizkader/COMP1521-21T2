#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
    long int total = 0;      
    int i = 1;
    while (i < argc) {
        FILE *stream = fopen(argv[i], "r");
        if (stream == NULL) {
            perror(argv[i]);
            return 1;
        }
        struct stat s;
        if (stat(argv[i], &s) != 0) {
            perror(argv[i]);
            exit(1);
        }
        //int stat(stream, &s);
        
        printf("%s: %ld bytes\n", argv[i], s.st_size);
        total = total + s.st_size;
        
        fclose(stream);
        i++;
    }
    //printf("%d",i);
    printf("Total: %ld bytes\n", total);
    return 0;
    
}    