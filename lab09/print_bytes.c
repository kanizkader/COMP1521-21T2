#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *stream = fopen(argv[1], "r");
    if (stream == NULL) {
        perror(argv[1]);
        return 1;
    }
    int c;
    size_t i = 0;
    while ((c = fgetc(stream)) != EOF) {
        
        printf("byte %4ld: %3d 0x%02x", i, c, c);
        isprint(c);
        if (isprint(c) != 0) {
            printf(" '%c'\n", c);
        }
        else {
            printf("\n");
        }
        
        i++;
    }
    fclose(stream);
    return 0;
}