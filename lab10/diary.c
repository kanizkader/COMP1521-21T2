#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <spawn.h>

int main(int argc, char *argv[]) {
    
    char *home_dir = getenv("HOME");
    char *argument = (".diary");

    int arg_len = strlen(home_dir) + strlen(argument) + 2;
			char arg_name[arg_len];
			snprintf(arg_name, 
				sizeof arg_name, 
				"%s/%s", home_dir, argument);
    //printf("%s\n", arg_name);
    FILE *stream = fopen(arg_name, "a+");        
    //int c;
    int i = 1;
    while (i < argc) {
        //while (argv[i] == c) != EOF) {        
            fprintf(stream,"%s ",argv[i] );  
            i++;      
        //}
        
        
    }
    fprintf(stream, "\n");
    fclose(stream); 
    return 0;
}    