#ifndef LUSTAPRO_LIST_H
#define LUSTAPRO_LIST_H

#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

// to everyone reading this trying to understand:
// number handling in this is weird. for example, trailing zeroes are a thing and you have to handle them in equality and less-than checks and addition and so on.
// also, the addition algorithm is kind of unusual and likely not what you'd find in other people's implementation of this.
// i've tried to add some comments but they might not be entirely explanatory, feel free to email me or write to me on discord and i'll be happy to explain (if i remember that is :p)

// no separate list/node type, these are the basic building blocks of the whole thing anyway so might as well be consistent and use one thing everywhere
// an empty list has value equal to zero since we're never going to store a null character in a string or int
// note: this type is usually not supposed to be on the stack. malloc all the things
typedef struct lustapro_list {
    char value;
    struct lustapro_list* next;
} lsp_list_t;

// =================
// list construction
// =================

// Allocate a new empty list and return it.
lsp_list_t* lsp_list_new();

// Allocate a new single-element list and return it.
lsp_list_t* lsp_list_single(char el);

// Clone an existing list.
lsp_list_t* lsp_list_clone(lsp_list_t* l);

// Destroy a list, freeing the memory of all its nodes.
void lsp_list_destroy(lsp_list_t* l);

// ==============
// list traversal
// ==============

// Return the last element of the list.
lsp_list_t* lsp_list_end(lsp_list_t* l);

// Return the second to last element of the list.
lsp_list_t* lsp_list_2tail(lsp_list_t* l);

size_t lsp_list_length(lsp_list_t* l);

// =================
// list manipulation
// =================

// Insert an element at the front of the list.
lsp_list_t* lsp_list_push(lsp_list_t* l, char el);

// Insert an element at the back of the list.
lsp_list_t* lsp_list_push_back(lsp_list_t* l, char el);

// Pop the element from the front of the list. Preserves the address of the list head.
char lsp_list_pop(lsp_list_t* l);

// Pop the element from the back of the list.
char lsp_list_pop_back(lsp_list_t* l);

void lsp_list_concat(lsp_list_t* left, lsp_list_t* right);

// ====
// misc
// ====

void lsp_list_print(lsp_list_t* l);

bool lsp_list_is_false(lsp_list_t* l);

// ===============
// number handling
// ===============

// Convert a list to an integer and write into out.
// Returns whether the conversion succeded.
// If the conversion fails, the value of *out is undefined.
// Possible failure scenarios are a non-numeric list or integer overflow.
bool lsp_list_numberize(lsp_list_t *l, long long int *out);

// Convert an integer to a list.
lsp_list_t* lsp_list_unnumberize(long long int num);

// Determine if two lists are numerically* equal.
// *an empty list will never compare equal to a non-empty list
bool lsp_list_num_equal(lsp_list_t* left, lsp_list_t* right);

// Determine if one list is numerically smaller than the other.
bool lsp_list_num_lessthan(lsp_list_t* left, lsp_list_t* right);

// Add two number-like lists and return a new list with the result of the addition.
lsp_list_t* lsp_list_num_add(lsp_list_t* left, lsp_list_t* right);

#endif // LUSTAPRO_LIST_H
