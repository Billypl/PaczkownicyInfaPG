#ifndef LUSTAPRO_STACK_H
#define LUSTAPRO_STACK_H

#include "list.h"
#include <stddef.h>
struct lustapro_execstack_node {
    lsp_list_t* value;
    struct lustapro_execstack_node* next;
};

typedef struct lustapro_execstack {
    struct lustapro_execstack_node* top;
    size_t height;
} lsp_execstack_t;

// Create an empty execution stack.
lsp_execstack_t lsp_execstack_create();

// Push a list onto the execution stack.
void lsp_execstack_push(lsp_execstack_t* self, lsp_list_t* list);

// Pop a list from the execution stack and return it.
lsp_list_t* lsp_execstack_pop(lsp_execstack_t* self);

// Return the list on the idx-th position (0 is top of stack) on the stack without removing it.
lsp_list_t* lsp_execstack_get(lsp_execstack_t* self, size_t idx);

// Exchange the top 2 elements on the stack.
void lsp_execstack_exch(lsp_execstack_t* self);

// Print the execution stack onto stdout.
void lsp_execstack_print(lsp_execstack_t* self);

// Destroy the execution stack and free any leftover lists.
void lsp_execstack_destroy(lsp_execstack_t* self);
#endif // LUSTAPRO_STACK_H
