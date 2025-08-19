#include "stack.h"
#include "list.h"
#include <stddef.h>
#include <stdlib.h>

typedef struct lustapro_execstack_node node_t;

lsp_execstack_t lsp_execstack_create() {
    lsp_execstack_t r;
    r.top = NULL;
    r.height = 0;
    return r;
}

struct lustapro_execstack_node* make_node() {
    node_t* new = (node_t*) malloc(sizeof(node_t));
    new->value = NULL;
    new->next = NULL;
    return new;
}

void lsp_execstack_push(lsp_execstack_t *self, lsp_list_t* list) {
    node_t* n = make_node();
    n->value = list;
    if (self->top) n->next = self->top;
    self->top = n;
    self->height++;
}

lsp_list_t* lsp_execstack_pop(lsp_execstack_t *self) {
    if (self->top) {
        node_t* old_top = self->top;
        lsp_list_t* old_value = self->top->value;
        self->top = self->top->next;
        free(old_top);
        self->height--;
        return old_value;
    }

    return NULL;
}

node_t* lsp_execstack_get_inner(node_t* node, size_t remainingDepth) {
    if (remainingDepth == 0 || !node) return node;
    return lsp_execstack_get_inner(node->next, remainingDepth - 1);
}

lsp_list_t* lsp_execstack_get(lsp_execstack_t* self, size_t idx) {
    node_t* targetNode = lsp_execstack_get_inner(self->top, idx);
    if (!targetNode) return NULL;
    return targetNode->value;
}

void lsp_execstack_exch(lsp_execstack_t *self) {
    if (!self->top->next) return;
    node_t* old_next = self->top->next;
    // set the top node to point to the 3rd node on the stack
    self->top->next = self->top->next->next;
    // set the new top node to point to the old top node
    old_next->next = self->top;
    // set the new top node
    self->top = old_next;
}

void lsp_execstack_print_inner(node_t* node, size_t currentDepth) {
    if (!node) return;
    lsp_execstack_print_inner(node->next, currentDepth + 1);
    printf("%zu: ", currentDepth);
    lsp_list_print(node->value);
    putchar('\n');
}

void lsp_execstack_print(lsp_execstack_t* self) {
    lsp_execstack_print_inner(self->top, 0);
}

void lsp_execstack_destroy(lsp_execstack_t* self) {
    if (self->top) {
        lsp_list_t* list = lsp_execstack_pop(self);
        lsp_list_destroy(list);
        lsp_execstack_destroy(self);
    }
}
