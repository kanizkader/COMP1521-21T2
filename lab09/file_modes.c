#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
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
        
        if (S_ISDIR(s.st_mode)) {
            printf("d");
        }
        else {
            printf("-");
        }
        if ((s.st_mode & S_IRUSR)) {
            printf("r");
        }
        else {
            printf("-");
        }
        if ((s.st_mode & S_IWUSR)) {
            printf("w");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IXUSR) {
            printf("x");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IRGRP) {
            printf("r");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IWGRP) {
            printf("w");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IXGRP) {
            printf("x");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IROTH) {
            printf("r");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IWOTH) {
            printf("w");
        }
        else {
            printf("-");
        }
        if (s.st_mode & S_IXOTH) {
            printf("x");
        }
        else {
            printf("-");
        }
        
        printf(" %s\n", argv[i]);
        fclose(stream);
        i++;
    }
    
    return 0;

}