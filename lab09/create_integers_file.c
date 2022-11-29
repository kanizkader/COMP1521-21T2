#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }
    FILE *stream = fopen(argv[1], "w");
    if (stream == NULL) {
        perror(argv[1]);
        return 1;
    }
    int i = atoi(argv[2]);  

    while (i <= atoi(argv[3])) {
        fprintf(stream, "%d\n", i);
        i++;
    }    
    fclose(stream);
    return 0;
}