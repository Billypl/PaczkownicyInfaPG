#include "exec.h"
#include "list.h"
#include "stack.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CMD_CASE(char, fn) case char: \
    fn(self); \
    break;

lsp_executor_t lsp_make_executor(char *program) {
    lsp_executor_t r;
    r.stack = lsp_execstack_create();
    r.program = program;
    r.program_size = strlen(program);
    r.instruction_pointer = 0;
    return r;
}

void lsp_execute(lsp_executor_t *self) {
    while(lsp_execute_cycle(self)) {}
    lsp_execstack_destroy(&self->stack);
}

void lsp_execstack_clone_nth(lsp_execstack_t* self, size_t nth) {
    lsp_list_t* top_list = lsp_execstack_get(self, nth);
    lsp_execstack_push(self, lsp_list_clone(top_list));
}

void lsp_executor_do_dupnth(lsp_executor_t* self) {
    lsp_list_t* nth = lsp_execstack_pop(&self->stack);
    long long int nth_num;
    lsp_list_numberize(nth, &nth_num);
    lsp_list_destroy(nth);
    lsp_execstack_clone_nth(&self->stack, nth_num);
}

void lsp_executor_do_pushstdin(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_get(&self->stack, 0);
    lsp_list_push(top, getchar());
}

void lsp_executor_do_writechar(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_pop(&self->stack);
    putchar(top->value);
    lsp_list_destroy(top);
}

void lsp_executor_do_negate(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_get(&self->stack, 0);
    lsp_list_t* secondlast = lsp_list_2tail(top);
    if (secondlast) {
        // secondlast->next is guaranteed non-null by 2tail
        if (secondlast->next->value == '-') {
            // technically incurs a immediately returning call to 2tail
            // but it's fine
            lsp_list_pop_back(secondlast);
        } else {
            lsp_list_push_back(secondlast, '-');
        }
    } else {
        // 0 or 1 length list
        top->value = top->value == '-' ?
            0 : '-';
    }
}

void lsp_executor_do_abs(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_get(&self->stack, 0);
    lsp_list_t* secondlast = lsp_list_2tail(top);
    if (secondlast) {
        if (secondlast->next->value == '-') {
            lsp_list_pop_back(secondlast);
        }
    } else {
        // 0 or 1 length
        if (top->value == '-') {
            top->value = 0;
        }
    }
}

void lsp_executor_do_chr(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_pop(&self->stack);
    long long int numeric_value;
    lsp_list_numberize(top, &numeric_value);
    lsp_list_t* char_list = lsp_list_single((char)numeric_value);
    lsp_execstack_push(&self->stack, char_list);
    lsp_list_destroy(top);
}

void lsp_executor_do_ord(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_pop(&self->stack);
    char first_char = top->value;
    lsp_list_destroy(top);
    lsp_execstack_push(&self->stack, lsp_list_unnumberize(first_char));
}

void lsp_executor_do_splitstr(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_get(&self->stack, 0);
    lsp_list_t* new_str = lsp_list_single(lsp_list_pop(top));
    lsp_execstack_push(&self->stack, new_str);
}

void lsp_executor_do_concat(lsp_executor_t* self) {
    lsp_list_t* right = lsp_execstack_pop(&self->stack);
    lsp_list_t* left = lsp_execstack_get(&self->stack, 0);
    lsp_list_concat(left, right);
}

void lsp_executor_do_not(lsp_executor_t* self) {
    lsp_list_t* top = lsp_execstack_pop(&self->stack);
    if (lsp_list_is_false(top)) {
        lsp_execstack_push(&self->stack, lsp_list_single('1'));
    } else {
        lsp_execstack_push(&self->stack, lsp_list_single('0'));
    }
    lsp_list_destroy(top);
}

void lsp_executor_do_puship(lsp_executor_t* self) {
    lsp_execstack_push(&self->stack, lsp_list_unnumberize(self->instruction_pointer));
}

void lsp_executor_do_conditional(lsp_executor_t* self) {
    lsp_list_t* target = lsp_execstack_pop(&self->stack);
    lsp_list_t* cond = lsp_execstack_pop(&self->stack);
    if (!lsp_list_is_false(cond)) {
        long long int num_target;
        if (lsp_list_numberize(target, &num_target)) {
            self->instruction_pointer = num_target - 1; // incremented back up at end of cycle
        }
    }
    lsp_list_destroy(target);
    lsp_list_destroy(cond);
}

void lsp_executor_do_lessthan(lsp_executor_t* self) {
    lsp_list_t* right = lsp_execstack_pop(&self->stack);
    lsp_list_t* left = lsp_execstack_pop(&self->stack);
    char result = lsp_list_num_lessthan(left, right) ? '1' : '0';
    lsp_execstack_push(&self->stack, lsp_list_single(result));
    lsp_list_destroy(left);
    lsp_list_destroy(right);
}

void lsp_executor_do_equal(lsp_executor_t* self) {
    lsp_list_t* right = lsp_execstack_pop(&self->stack);
    lsp_list_t* left = lsp_execstack_pop(&self->stack);
    char result = lsp_list_num_equal(left, right) ? '1' : '0';
    lsp_execstack_push(&self->stack, lsp_list_single(result));
    lsp_list_destroy(left);
    lsp_list_destroy(right);
}

void lsp_executor_do_add(lsp_executor_t* self) {
    lsp_list_t* right = lsp_execstack_pop(&self->stack);
    lsp_list_t* left = lsp_execstack_pop(&self->stack);
    lsp_list_t* result = lsp_list_num_add(left, right);
    lsp_execstack_push(&self->stack, result);
    lsp_list_destroy(left);
    lsp_list_destroy(right);
}

bool lsp_execute_cycle(lsp_executor_t *self) {
    if (self->instruction_pointer > self->program_size) return false;

    char opcode = self->program[self->instruction_pointer];
    #ifdef DETAIL_TRACE
    printf("\n\n====== STACKTRACE ip=%d instr=%c =======\n", self->instruction_pointer, opcode);
    lsp_execstack_print(&self->stack);
    #endif

    switch (opcode) {
        case '\0':
        case '\n':
            return false;
        case '\'':
            lsp_execstack_push(&self->stack, lsp_list_new());
            break;

        case ',':
            lsp_list_destroy(lsp_execstack_pop(&self->stack));
            break;

        case ';':
            lsp_execstack_exch(&self->stack);
            break;

        case ':':
            lsp_execstack_clone_nth(&self->stack, 0);
            break;

        CMD_CASE('@', lsp_executor_do_dupnth)
        CMD_CASE('.', lsp_executor_do_pushstdin)
        CMD_CASE('>', lsp_executor_do_writechar)
        CMD_CASE('-', lsp_executor_do_negate)
        CMD_CASE('^', lsp_executor_do_abs)
        CMD_CASE('[', lsp_executor_do_ord)
        CMD_CASE(']', lsp_executor_do_chr)
        CMD_CASE('$', lsp_executor_do_splitstr)
        CMD_CASE('#', lsp_executor_do_concat)
        CMD_CASE('=', lsp_executor_do_equal)
        CMD_CASE('<', lsp_executor_do_lessthan)
        CMD_CASE('~', lsp_executor_do_puship)
        CMD_CASE('!', lsp_executor_do_not)
        CMD_CASE('?', lsp_executor_do_conditional)
        CMD_CASE('+', lsp_executor_do_add)

        case '&':
            #ifndef DETAIL_TRACE
            lsp_execstack_print(&self->stack);
            #endif
            break;

        default:
            lsp_list_push(self->stack.top->value, opcode);
            break;
    }

    self->instruction_pointer++;
    return true;
}
