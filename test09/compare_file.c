#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *stream = fopen(argv[1], "r");
    //int i = 1;
    //long int d = 0;
    //long int c = 0;
    //struct stat s;
    //while (i < argc) {
        fseek(stream, 0L, SEEK_END);
        long int c = ftell(stream);
    //}
        //printf("%s: %ld bytes\n", argv[i], s.st_size);
    fclose(stream);
    FILE *stream2 = fopen(argv[2], "r");
     fseek(stream2, 0L, SEEK_END);
        long int d = ftell(stream2);
    fclose(stream2);

    if (c == d) {
        printf("Files are identical\n");

    }

    if (c < d) {
        printf("EOF on %s\n", argv[1]);
    }
    if (c > d) {
        printf("EOF on %s\n", argv[2]);
    }
}    