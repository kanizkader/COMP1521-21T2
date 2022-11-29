#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
    FILE *stream = fopen(argv[1], "r");
    int c;
    //char command_string[2096];
    int check = 0;
    size_t i = 0;

    while ((c = fgetc(stream)) != EOF) {                
        
        isprint(c);
        if (isprint(c) != 0) {
            check = 1;
            break;
        }
        if (c >= 125 || c <= 255) {
            break;
        }  
        i++;
                      
    }
     if (check == 0) {
               printf("%s: byte %ld is non-ASCII\n", argv[1], i);
            }

    
    fclose(stream);

}