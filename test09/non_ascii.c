#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *stream = fopen(argv[0], "r");
    int c;
    //char command_string[2096];
    int check = 0;
    size_t i = 0;

    while ((c = fgetc(stream)) != EOF) {                
        //int num = atoi(argv[0]);
        //if ((atoi(c) <= 125) || (atoi(c) >= 255)) {
            
          //  return 0;            
        //}
        isprint(c);
        if (isprint(c) != 0) {
            //printf("%s: %4ld is non-ASCII\n", argv[1], i);
            check = 1;

            break;
        }
        else {
           // printf("%s is all ASCII\n", argv[1]);
           check = 0;
        }
        
        i++;
        //else {
           

        //}
                    
    }
     if (check == 1) {
                printf("%s is all ASCII\n", argv[1]);
            }
else {
    printf("%s: byte %ld is non-ASCII\n", argv[1], i+4);
}
    
    fclose(stream);

}    