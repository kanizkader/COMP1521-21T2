// COMP1521 21T2 ... final exam, question 3

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void
cp (char *path_from, char *path_to)
{
	// TODO
   
    FILE *stream1 = fopen(path_from, "rb");
    FILE *stream2 = fopen(path_to, "wb");
    
    while (1) {
        char bytes[BUFSIZ];
        size_t bytes_read = fread(bytes, 1, sizeof bytes, stream1);
        if (bytes_read <= 0) {
            break;
        }
        fwrite(bytes, 1, bytes_read, stream2);
    }

    fclose(stream1);  
    fclose(stream2); 

}

