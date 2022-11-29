////////////////////////////////////////////////////////////////////////
// COMP1521 21t2 -- Assignment 2 -- shuck, A Simple Shell
// <https://www.cse.unsw.edu.au/~cs1521/21T2/assignments/ass2/index.html>
//
// Written by Kaniz Kader (z5363412) on 29/08/21
//
// 2021-07-12    v1.0    Team COMP1521 <cs1521@cse.unsw.edu.au>
// 2021-07-21    v1.1    Team COMP1521 <cs1521@cse.unsw.edu.au>
//     * Adjust qualifiers and attributes in provided code,
//       to make `dcc -Werror' happy.
//

#include <sys/types.h>

#include <sys/stat.h>
#include <sys/wait.h>

#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <spawn.h>
#include <ctype.h>
#include <glob.h>


//
// Interactive prompt:
//     The default prompt displayed in `interactive' mode --- when both
//     standard input and standard output are connected to a TTY device.
//
static const char *const INTERACTIVE_PROMPT = "shuck& ";

//
// Default path:
//     If no `$PATH' variable is set in Shuck's environment, we fall
//     back to these directories as the `$PATH'.
//
static const char *const DEFAULT_PATH = "/bin:/usr/bin";

//
// Default history shown:
//     The number of history items shown by default; overridden by the
//     first argument to the `history' builtin command.
//     Remove the `unused' marker once you have implemented history.
//
static const int DEFAULT_HISTORY_SHOWN __attribute__((unused)) = 10;

//
// Input line length:
//     The length of the longest line of input we can read.
//
static const size_t MAX_LINE_CHARS = 1024;

//
// Special characters:
//     Characters that `tokenize' will return as words by themselves.
//
static const char *const SPECIAL_CHARS = "!><|";

//
// Word separators:
//     Characters that `tokenize' will use to delimit words.
//
static const char *const WORD_SEPARATORS = " \t\r\n";


static void execute_command(char **words, char **path, char **environment);
static void do_exit(char **words);
static int is_executable(char *pathname);
static char **tokenize(char *s, char *separators, char *special_chars);
static void free_tokens(char **tokens);

static char *path_finder(char *word, char **path);
static char *store_history(char **words);
static char *print_history(char **words);
static char *print_specific_history(char **words, char **path, char **environment);
static char *print_specific_history_with_arg_num(char **words, char **path, char **environment);



int main (void)
{
    // Ensure `stdout' is line-buffered for autotesting.
    setlinebuf(stdout);

    // Environment variables are pointed to by `environ', an array of
    // strings terminated by a NULL value -- something like:
    //     { "VAR1=value", "VAR2=value", NULL }
    extern char **environ;

    // Grab the `PATH' environment variable for our path.
    // If it isn't set, use the default path defined above.
    char *pathp;
    if ((pathp = getenv("PATH")) == NULL) {
        pathp = (char *) DEFAULT_PATH;
    }
    char **path = tokenize(pathp, ":", "");

    // Should this shell be interactive?
    bool interactive = isatty(STDIN_FILENO) && isatty(STDOUT_FILENO);

    // Main loop: print prompt, read line, execute command
    while (1) {
        // If `stdout' is a terminal (i.e., we're an interactive shell),
        // print a prompt before reading a line of input.
        if (interactive) {
            fputs(INTERACTIVE_PROMPT, stdout);
            fflush(stdout);
        }

        char line[MAX_LINE_CHARS];
        if (fgets(line, MAX_LINE_CHARS, stdin) == NULL)
            break;

        // Tokenise and execute the input line.
        char **command_words =
            tokenize(line, (char *) WORD_SEPARATORS, (char *) SPECIAL_CHARS);
        execute_command(command_words, path, environ);
        free_tokens(command_words);
    }

    free_tokens(path);
    return 0;
}


//
// Execute a command, and wait until it finishes.
//
//  * `words': a NULL-terminated array of words from the input command line
//  * `path': a NULL-terminated array of directories to search in;
//  * `environment': a NULL-terminated array of environment variables.
//
static void execute_command(char **words, char **path, char **environment)
{
    assert(words != NULL);
    assert(path != NULL);
    assert(environment != NULL);

    char *program = words[0];

    if (program == NULL) {
        // nothing to do
        return;
    }

    if (strcmp(program, "exit") == 0) {
        do_exit(words);
        // `do_exit' will only return if there was an error.
        return;
    }

    // Prints history
    if (strcmp(program, "history") == 0) {

        // Counts how many words in the argument line.
        int num = 0;        
        while(words[num] != NULL) {
            num++;
        }
        
        // If there is more than one argument, prints error message.
        if (num > 2) {    
            // Stores command.    
            store_history(words);   
            // Prints error message.
            fprintf(stderr, "%s: too many arguments\n", program);
            return;
        }

        // If user inputs "history 0".
        if (strcmp(program, "0") == 0) {
            //Stores command.
            store_history(words);
            return;
        }

        // If history is followed by an argument.
        if (words[1] != NULL) {   

            // If argument is not a number.
            int k = atoi(words[1]);   
            if (k <= 0)  {  
                // Store command.
                store_history(words);          
                // Prints error message. 
                fprintf(stderr, "%s: %s: numeric argument required\n", program, words[1]);
                return;
            }            
        }        

        // If no errors, print history.    
        print_history(words);
        // Store command after printing.
        store_history(words);        
        return;

    }

    // To implement a previous command.
    if ((strcmp(program, "!") == 0)) {
        
        // If command number from history is not specified.
        if(words[1] != NULL) {
            print_specific_history(words, path, environment);
        }

        // If command number from history is specified.
        else if (words[1] == NULL) {
            print_specific_history_with_arg_num(words, path, environment);
        }
        return;         
    }  
    
    // Store the command in history.
    if (program != NULL) {
        store_history(words);        
    }  
    
    // Changes directory      
    if (strcmp(program, "cd") == 0) {

        // Change directory into given argument.
        if (words[1] != NULL) {
            if (chdir(words[1]) != 0) {
                // If it does not exist, prints error message.
                fprintf(stderr,"cd: %s: No such file or directory\n", words[1]);                   
            }                
        } 

        // If there is no command after cd.      
        else if (words[1] == NULL) {
            // Set to home directory           
            char *home_dir = getenv("HOME");
            chdir(home_dir);                        
        }           
        return;         
    }

    // Prints working directory.    
    if (strcmp(program, "pwd") == 0) {        	
        char *cwd_result = getcwd(NULL, 0);
        printf("current directory is '%s'\n", cwd_result);
        free(cwd_result);
        return;
    }
         
    bool is_found = false;
    char *full_path = NULL;

    // If command does not conatin '/'.
    if (strrchr(program, '/') == NULL) {       
        // Find the command's path          
        full_path = path_finder(program, path); 

        // If path was found, path_finder will return the path.
        if (full_path != NULL) {
            is_found = true;            
        }                     
    }

    // If command contains '/'.
    else {
        full_path = program;
        
        // Check if path is excutable.
        if (is_executable(full_path) == 1) {
            is_found = true;
        }
    }
    
    int status = 0;
    // If command found.
    if (is_found == true) {
        // pid of child process.            
        pid_t pid; 

        // Error for posix_spawn.
        if (posix_spawn(&pid, full_path, NULL, NULL, words, environment) != 0) {
            perror("spawn");
        }

        // Exit status of spawned processes.
        if (status == 0) {
            if (waitpid(pid, &status, 0) != -1) {
                printf("%s exit status = %i\n", full_path, WEXITSTATUS(status));                
            }
        }
    }
    // If command not found.
    else {
        fprintf(stderr, "%s: command not found\n", program);        
    }
       
    return;
}


//
// Implement the `exit' shell built-in, which exits the shell.
//
// Synopsis: exit [exit-status]
// Examples:
//     % exit
//     % exit 1
//
static void do_exit(char **words)
{
    assert(words != NULL);
    assert(strcmp(words[0], "exit") == 0);

    int exit_status = 0;

    if (words[1] != NULL && words[2] != NULL) {
        // { "exit", "word", "word", ... }
        fprintf(stderr, "exit: too many arguments\n");

    } else if (words[1] != NULL) {
        // { "exit", something, NULL }
        char *endptr;
        exit_status = (int) strtol(words[1], &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "exit: %s: numeric argument required\n", words[1]);
        }
    }

    exit(exit_status);
}


//
// Check whether this process can execute a file.  This function will be
// useful while searching through the list of directories in the path to
// find an executable file.
//
static int is_executable(char *pathname)
{
    struct stat s;
    return
        // does the file exist?
        stat(pathname, &s) == 0 &&
        // is the file a regular file?
        S_ISREG(s.st_mode) &&
        // can we execute it?
        faccessat(AT_FDCWD, pathname, X_OK, AT_EACCESS) == 0;
}


//
// Split a string 's' into pieces by any one of a set of separators.
//
// Returns an array of strings, with the last element being `NULL'.
// The array itself, and the strings, are allocated with `malloc(3)';
// the provided `free_token' function can deallocate this.
//
static char **tokenize(char *s, char *separators, char *special_chars)
{
    size_t n_tokens = 0;

    // Allocate space for tokens.  We don't know how many tokens there
    // are yet --- pessimistically assume that every single character
    // will turn into a token.  (We fix this later.)
    //printf("%s", s);
    char **tokens = calloc((strlen(s) + 1), sizeof *tokens);
    assert(tokens != NULL);

    while (*s != '\0') {
        // We are pointing at zero or more of any of the separators.
        // Skip all leading instances of the separators.
        s += strspn(s, separators);

        // Trailing separators after the last token mean that, at this
        // point, we are looking at the end of the string, so:
        if (*s == '\0') {
            break;
        }

        // Now, `s' points at one or more characters we want to keep.
        // The number of non-separator characters is the token length.
        size_t length = strcspn(s, separators);
        size_t length_without_specials = strcspn(s, special_chars);
        if (length_without_specials == 0) {
            length_without_specials = 1;
        }
        if (length_without_specials < length) {
            length = length_without_specials;
        }

        // Allocate a copy of the token.
        char *token = strndup(s, length);
        assert(token != NULL);
        s += length;

        // Add this token.
        tokens[n_tokens] = token;
        n_tokens++;
    }

    // Add the final `NULL'.
    tokens[n_tokens] = NULL;

    // Finally, shrink our array back down to the correct size.
    tokens = realloc(tokens, (n_tokens + 1) * sizeof *tokens);
    assert(tokens != NULL);

    return tokens;
}


//
// Free an array of strings as returned by `tokenize'.
//
static void free_tokens(char **tokens)
{
    for (int i = 0; tokens[i] != NULL; i++) {
        free(tokens[i]);
    }
    free(tokens);
}

static char *path_finder (char *word, char **path) {
    int j = 0;            
    while (path[j] != NULL) {        
        // Creates path.        
        int arg_len = strlen(path[j]) + strlen(word) + 2;
        char arg_name[arg_len];
        snprintf(arg_name, 
            sizeof arg_name, 
            "%s/%s", path[j], word);
        
        // Check if this path is executable.        
        if (is_executable(arg_name) == 1) {				
                    
            char *result = malloc (sizeof arg_name);
            strcpy(result, arg_name);

            // Return the path of the command.
            return result;
        }	                
        j++;           
    }         
    // If not executable, function returns NULL.
    return NULL;
}

static char *store_history(char **words) {
    // Get home path.
    char *history_path = getenv("HOME");
    char *argument = (".shuck_history");

    // Create shuck history path.
    int arg_len = strlen(history_path) + strlen(argument) + 2;
			char arg_name[arg_len];
			snprintf(arg_name, 
				sizeof arg_name, 
				"%s/%s", history_path, argument);

    // Open shuck_history file and apprehend.            
    FILE *h_file = fopen(arg_name, "a+");    

    // Print commands into file.
    int i = 0;        
    while (words[i] != NULL) {                   
        fprintf(h_file,"%s ", words[i]);    
        if (words[i + 1] == NULL) {
            fprintf(h_file, "\n");
        }     
        i++;      
    }    
    
    // Close file.
    fclose(h_file);
    return 0;
}

static char *print_history(char **words) {
    // Get home path
    char *history_path = getenv("HOME");                                 
    char *argument = (".shuck_history");

    // Create shuck history path
    int arg_len = strlen(history_path) + strlen(argument) + 2;
			char arg_name[arg_len];
			snprintf(arg_name, 
				sizeof arg_name, 
				"%s/%s", history_path, argument);

    // Open history file.            
    FILE *p_file = fopen(arg_name, "r");   
   
    // Count how many commands there are
    char command_string[MAX_LINE_CHARS];
    int counter = 0;  
    while ((fgets(command_string, MAX_LINE_CHARS,p_file)) != NULL) {                
        counter++;             
    }
    // Close file.
    fclose(p_file);

    // Repen history file.            
    FILE *q_file = fopen(arg_name, "r");
      
    int i = 0;
    int actual = counter - 10;   
    
    // If command is history   
    if (words[1] == NULL){

        // If there are less than 10 commands in history.
        if (counter <= 10) {
            while ((fgets(command_string, MAX_LINE_CHARS,q_file)) != NULL) {   
            // Print out command in terminal 
            printf("%d: %s",i, command_string);             
            i++;               
            }        
        }

        // Print the last 10 commands in history.
        while ((fgets(command_string, MAX_LINE_CHARS,q_file)) != NULL) {   
            // Print out command in terminal 
            while (i == actual) {        
                printf("%d: %s",i, command_string);
                actual++;
            }
            i++;               
        }
    }     
    // Close the file.
    fclose(q_file);

    // Repen history file.
    FILE *r_file = fopen(arg_name, "r");

    // If command is history and number of printed commands are given
    if (words[1] != NULL) {  

        // Take the number of commands wanted by user  
        int num_args_wanted = atoi(words[1]);              

        int j = 0;
        int print_wanted = 0;
        // Holds where we want to start printing from.
        j =  counter - num_args_wanted; 

        // Print the commands in history
        while ((fgets(command_string, MAX_LINE_CHARS,r_file)) != NULL) {                        
            if (print_wanted == j) {         
                printf("%d: %s",j, command_string);
                j++;
            }             
            print_wanted++;             
        }
    }   

    // Close file
    fclose(r_file);
    return 0;
}

static char *print_specific_history(char **words, char **path, char **environment ) {
    // Get home path
    char *history_path2 = getenv("HOME");                                 
    char *argument2 = (".shuck_history");

    // Create shuck history path
    int arg_len2 = strlen(history_path2) + strlen(argument2) + 2;
	char arg_name2[arg_len2];
	snprintf(arg_name2, 
			sizeof arg_name2, 
			"%s/%s", 
            history_path2, 
            argument2);

    char command_string1[MAX_LINE_CHARS];      
      
    
    // Open history file            
    FILE *a_file = fopen(arg_name2, "r");
    char *result = NULL;
    int c_wanted = atoi(words[1]);
    int i = 0;
    
    // Find the wanted command
    while ((fgets(command_string1, MAX_LINE_CHARS,a_file)) != NULL) {                        
        if (i == c_wanted) {      
            result = malloc(sizeof command_string1);
            strcpy(result, command_string1);
            printf("%s", result);
            break;
        }             
        i++;            
    }           

    // Finds the arguments. 
    char **result_h = tokenize(result, (char *) WORD_SEPARATORS, (char *) SPECIAL_CHARS);
    fclose(a_file);


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPLEMENTS SUBSET 1 AGAIN
    // Store arguments in history
    store_history(result_h);
    
    // If command is "history".
     if (strcmp(result_h[0], "history") == 0) {

        // Count commands in history history. 
        int num = 0;        
        while(result_h[num] != NULL) {
            num++;
        }
        
        // If more than 1 argument.
        if (num > 2) {           
            fprintf(stderr, "%s: too many arguments\n", result_h[0]);
            return 0;
        }

        // If history file is empty
        if (strcmp(result_h[0], "0") == 0) {
            return 0;
        }

        // If argument given.
        if (result_h[1] != NULL) {
            
            // If argument is not a number.
            int k = atoi(result_h[1]);        
            if (k <= 0)  {  
                //store_history(result_h);           
                fprintf(stderr, "%s: %s: numeric argument required\n", result_h[0], result_h[1]);
                return 0;
            }
        }               
            // Print history.
            print_history(result_h);
                    
        return 0;
    }

          
    if (strcmp(result_h[0], "cd") == 0) {
        // If there is a command after cd
        if (result_h[1] != NULL) {
            if (chdir(result_h[1]) != 0) {
                fprintf(stderr,"cd: %s: No such file or directory\n", result_h[1]);                   
            }                
        } 
        // If there is no command after cd       
        else if (result_h[1] == NULL) {
            // Set to home directory           
            char *home_dir = getenv("HOME");
            chdir(home_dir);                        
        }           
        return 0;         
    }
        
    if (strcmp(result_h[0], "pwd") == 0) {        	
        char *cwd_result = getcwd(NULL, 0);
        printf("current directory is '%s'\n", cwd_result);
        free(cwd_result);
        return 0;
    }
    
    // [[ TODO: change code below here to implement subset 1 ]] 
    //subset 5 : waitpid   
    bool is_found = false;
    char *full_path = NULL;

    // If command does not conatin '/'
    if (strrchr(result_h[0], '/') == NULL) {       
        // Find the command's path          
        full_path = path_finder(result_h[0], path); 

        // If path was found, path_finder will return the path
        if (full_path != NULL) {
            is_found = true;            
        }                     
    }
    // If command contains '/'
    else {
        full_path = result_h[0];
        
        // Check if path is excutable
        if (is_executable(full_path) == 1) {
            is_found = true;
        }
    }
    
    int status = 0;
    // If command found
    if (is_found == true) {
        // pid of child process             
        pid_t pid; 

        // Error for posix_spawn
        if (posix_spawn(&pid, full_path, NULL, NULL, result_h, environment) != 0) {
            perror("spawn");
        }

        // Exit status of spawned processes
        if (status == 0) {
            if (waitpid(pid, &status, 0) != -1) {
                printf("%s exit status = %i\n", full_path, WEXITSTATUS(status));
                return 0;
            }
        }
    }
    // If command not found
    else {
        fprintf(stderr, "%s: command not found\n", result_h[0]);        
    }
    
    return 0;    
}

static char *print_specific_history_with_arg_num(char **words, char **path, char **environment ) {
    // Get home path
    char *history_path2 = getenv("HOME");                                 
    char *argument2 = (".shuck_history");

    // Create shuck history path
    int arg_len2 = strlen(history_path2) + strlen(argument2) + 2;
	char arg_name2[arg_len2];
	snprintf(arg_name2, 
			sizeof arg_name2, 
			"%s/%s", 
            history_path2, 
            argument2);

    // Open history file            
    FILE *p_file = fopen(arg_name2, "r");   
   
    // Count how many commands there are
    char command_string1[MAX_LINE_CHARS];
    int counter = 0;  
    while ((fgets(command_string1, MAX_LINE_CHARS,p_file)) != NULL) {                
        counter++;             
    }
    fclose(p_file);

    // Open history file
    FILE *s_file = fopen(arg_name2, "r");
    char *result = NULL;
    
    // If history empty.
    if (counter == 0) {
        fprintf(stderr, "!: invalid history reference");
    }
    int c_wanted = counter;            
    int i = 1;            

    // Do command from hsitory.
    while ((fgets(command_string1, MAX_LINE_CHARS,s_file)) != NULL) {                    
        if (i == c_wanted) {      
            result = malloc(sizeof command_string1);
            strcpy(result, command_string1);
            printf("%s", result);
            break;
        }             
        i++;            
    }     

    // Find arguments.
    char **result_h = tokenize(result, (char *) WORD_SEPARATORS, (char *) SPECIAL_CHARS);
    

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPLEMENTS SUBSET 1 AGAIN

    store_history(result_h);
      
    
    if (strcmp(result_h[0], "history") == 0) {
        int num = 0;        
        while(result_h[num] != NULL) {
            num++;
        }
        
        if (num > 2) {           
            fprintf(stderr, "%s: too many arguments\n", result_h[0]);
            return 0;
        }

        if (strcmp(result_h[0], "0") == 0) {
            return 0;
        }

        if (result_h[1] != NULL) {            
            int k = atoi(result_h[1]);        
            if (k <= 0)  {             
                fprintf(stderr, "%s: %s: numeric argument required\n", result_h[0], result_h[1]);
                return 0;
            }
        }               
            print_history(result_h);
                    
        return 0;
    }
     
    if (strcmp(result_h[0], "cd") == 0) {
        // If there is a command after cd
        if (result_h[1] != NULL) {
            if (chdir(result_h[1]) != 0) {
                fprintf(stderr,"cd: %s: No such file or directory\n", result_h[1]);                   
            }                
        } 
        // If there is no command after cd       
        else if (result_h[1] == NULL) {
            // Set to home directory           
            char *home_dir = getenv("HOME");
            chdir(home_dir);                        
        }           
        return 0;         
    }
        
    if (strcmp(result_h[0], "pwd") == 0) {        	
        char *cwd_result = getcwd(NULL, 0);
        printf("current directory is '%s'\n", cwd_result);
        free(cwd_result);
        return 0;
    }
      
    bool is_found = false;
    char *full_path = NULL;

    // If command does not conatin '/'
    if (strrchr(result_h[0], '/') == NULL) {       
        // Find the command's path          
        full_path = path_finder(result_h[0], path); 

        // If path was found, path_finder will return the path
        if (full_path != NULL) {
            is_found = true;            
        }                     
    }
    // If command contains '/'
    else {
        full_path = result_h[0];
        
        // Check if path is excutable
        if (is_executable(full_path) == 1) {
            is_found = true;
        }
    }
    
    int status = 0;
    // If command found
    if (is_found == true) {
        // pid of child process             
        pid_t pid; 

        // Error for posix_spawn
        if (posix_spawn(&pid, full_path, NULL, NULL, result_h, environment) != 0) {
            perror("spawn");
        }

        // Exit status of spawned processes
        if (status == 0) {
            if (waitpid(pid, &status, 0) != -1) {
                printf("%s exit status = %i\n", full_path, WEXITSTATUS(status));
                return 0;
            }
        }
    }
    // If command not found
    else {
        fprintf(stderr, "%s: command not found\n", result_h[0]);        
    }

    // Close file.
    fclose(s_file);
    return 0;
}    


