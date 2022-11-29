#include <stdio.h>

#include "put_string.h"

#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// print s to stdout with a new line appended using fputc (only)

void put_string(char *s) {

   // PUT YOUR CODE HERE

   FILE *stream = fopen("put_string_file", "a+");
    
   int i = 0;
   int c = 0;
   while (c != NULL) {  
      c = atoi(&s[i]);  
      fputc(c, stream);
   }   
   
   fputc(atoi("\n"), stream);
   fclose(stream);
   

    
}
