#ifndef LUSTAPRO_EXEC_H
#define LUSTAPRO_EXEC_H

#include <stddef.h>
#include <stdbool.h>
#include "stack.h"

typedef struct lustapro_executor {
    char* program;
    size_t program_size;
    size_t instruction_pointer;
    lsp_execstack_t stack;
} lsp_executor_t;

// Create an executor with the specified program buffer. The buffer passed in should not be modified for the lifetime of the executor.
lsp_executor_t lsp_make_executor(char* program);

// Execute program continously until execution ends.
void lsp_execute(lsp_executor_t* self);

// Execute one instruction.
bool lsp_execute_cycle(lsp_executor_t* self);

#endif // LUSTAPRO_EXEC_H
