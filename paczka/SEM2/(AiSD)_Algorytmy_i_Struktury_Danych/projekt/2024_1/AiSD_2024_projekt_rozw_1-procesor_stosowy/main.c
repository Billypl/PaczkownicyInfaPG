#include "exec.h"
#include <stdio.h>
#include <stdlib.h>
#define MAX_PROG_SIZE 20000

#ifndef TEST_MAIN
int main() {
    char* program_buffer = (char*) malloc((MAX_PROG_SIZE + 2) * sizeof(char));
    fgets(program_buffer, MAX_PROG_SIZE, stdin);
    lsp_executor_t exec = lsp_make_executor(program_buffer);
    lsp_execute(&exec);
    free(program_buffer);
    return 0;
}
#endif
