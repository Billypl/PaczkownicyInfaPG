#include "list.h"

#include <ctype.h>
#include <limits.h>
#include <stdlib.h>

lsp_list_t* lsp_list_new() {
    lsp_list_t* new_list = (lsp_list_t*) malloc(sizeof(lsp_list_t));
    new_list->value = 0;
    new_list->next = NULL;
    return new_list;
}

// Allocate a new single-element list and return it.
lsp_list_t* lsp_list_single(char el) {
    lsp_list_t* l = lsp_list_new();
    l->value = el;
    return l;
}

void lsp_list_clone_inner(lsp_list_t* from, lsp_list_t* to) {
    to->value = from->value;
    if (from->next) {
        lsp_list_t* new_node = lsp_list_new();
        to->next = new_node;
        lsp_list_clone_inner(from->next, new_node);
    }
}

// Clone an existing list.
lsp_list_t* lsp_list_clone(lsp_list_t* l) {
    lsp_list_t* new = lsp_list_new();
    lsp_list_clone_inner(l, new);
    return new;
}

// Destroy a list, freeing the memory of all its nodes.
void lsp_list_destroy(lsp_list_t* l) {
    if (!l) return;
    lsp_list_t* next = l->next;
    free(l);
    lsp_list_destroy(next);
}

// Return the last element of the list.
lsp_list_t* lsp_list_end(lsp_list_t* l) {
    if (!l->next) return l;
    return lsp_list_end(l->next);
}

lsp_list_t* lsp_list_2tail(lsp_list_t* l) {
    if (l->next == NULL) return NULL; // list is 0 or 1 length; should never happen unless a 1-list is passed to the function
    if (l->next->next == NULL) return l; // this element is 2 away from end, return it
    return lsp_list_2tail(l->next);
}

// Insert an element at the front of the list.
lsp_list_t* lsp_list_push(lsp_list_t* l, char el) {
    // handle empty list
    if (!l->value) {
        l->value = el;
        return l;
    }

    // copy the previous head into a new element and replace the original to keep the head address constant
    lsp_list_t* new = lsp_list_single(l->value);
    new->next = l->next;
    l->value = el;
    l->next = new;
    return l;
}

// Insert an element at the back of the list.
lsp_list_t* lsp_list_push_back(lsp_list_t* l, char el) {
    lsp_list_t* last = lsp_list_end(l);
    lsp_list_t* new = lsp_list_single(el);
    last->next = new;
    return l;
}

// this is head-preserving now
char lsp_list_pop(lsp_list_t* l) {
    char value = l->value; // get the value that will be "popped"
    if (l->next) {
        // set l to be the element after l
        lsp_list_t* old_next = l->next;
        l->value = l->next->value;
        l->next = l->next->next;
        // destroy l->next since it's no longer needed
        free(old_next);
    } else {
        l->value = 0;
    }
    return value;
}


char lsp_list_pop_back(lsp_list_t* l) {
    if (!l->next) { // 0 or 1 element list
        return l->value; // returns \0 for 0-el list
    }
    lsp_list_t* secondlast = lsp_list_2tail(l);
    char r = secondlast->next->value;
    free(secondlast->next);
    secondlast->next = NULL;
    return r;
}

void lsp_list_concat(lsp_list_t* left, lsp_list_t* right) {
    // right list empty
    if (!right->value) {
        return;
    }

    // left list empty (just set to right in that case)
    if (!left->value) {
        *left = *right;
        return;
    }

    lsp_list_t* left_end = lsp_list_end(left);
    left_end->next = right;
}

void lsp_list_print(lsp_list_t* l) {
    if (l && l->value) {
        #ifndef DETAIL_TRACE
        putchar(l->value);
        #endif
        #ifdef DETAIL_TRACE
        printf("[%c (%d)]", l->value, l->value);
        #endif
        lsp_list_print(l->next);
    }
}

bool lsp_list_is_false(lsp_list_t* l) {
    return !l->value || (l->value == '0' && l->next == NULL);
}

// the rudimentary overflow check is maybe incomplete and definitely unnecessary and not hit in any of the tests, however i added it just for fun i suppose
bool lsp_list_numberize_inner(lsp_list_t* l, long long int *out, long long int mult) {
    if (!l) return true;

    if (l->value == '-') {
        *out *= -1;
        return true;
    }

    if (!isdigit(l->value)) {
        return false;
    }

    int digit = l->value - '0';
    long long int headroom = LLONG_MAX - digit * mult;
    if (headroom < 0) {
        return false;
    }

    *out += digit * mult;
    // fixme: check if mult*10 would overflow
    return lsp_list_numberize_inner(l->next, out, mult*10);
}

bool lsp_list_numberize(lsp_list_t *l, long long int *out) {
    *out = 0;
    return lsp_list_numberize_inner(l, out, 1);
}

void lsp_list_unnumberize_inner(lsp_list_t* list, long long num) {
    if (num == 0) return;

    char mod = num % 10 + '0';
    lsp_list_unnumberize_inner(list, num/10);
    lsp_list_push(list, mod);
}

lsp_list_t* lsp_list_unnumberize(long long int num) {
    if (num == 0) return lsp_list_single('0');

    lsp_list_t* new_node = lsp_list_new();
    if (num < 0) {
        lsp_list_push(new_node, '-');
        num *= -1;
    }
    lsp_list_unnumberize_inner(new_node, num);
    return new_node;
}

// Gets a digit out of the list, returning 0 if it's exhausted. Then it advances the list by one element. Probably caused more trouble than it removed, but it's here already so whatever.
int lsp_list_effective_digit(lsp_list_t** l) {
    if (*l) {
        int val = (*l)->value - '0';
        *l = (*l)->next;
        return val;
    } else {
        return 0;
    }
}

bool lsp_list_num_equal_inner(lsp_list_t* left, lsp_list_t* right, bool zero, bool left_neg, bool right_neg) {
    int effective_digit_left, effective_digit_right;
    effective_digit_left = lsp_list_effective_digit(&left);
    effective_digit_right = lsp_list_effective_digit(&right);
    left_neg = left_neg || effective_digit_left == '-' - '0'; // another pain point of the effective digit function, i have to do *this* to check if it's a minus sign
    right_neg = right_neg || effective_digit_right == '-' - '0';

    // turn - into 0
    effective_digit_left = effective_digit_left < 0 ? 0 : effective_digit_left;
    effective_digit_right = effective_digit_right < 0 ? 0 : effective_digit_right;

    // if both numbers were zero and the next 'digit' is either a 0 or a - for both, they're still zero
    zero = zero && (effective_digit_left == 0) && (effective_digit_right == 0);

    if (effective_digit_left != effective_digit_right) {
        // discrepancy between the effective digits; this means the lists are numerically unequal
        // except if 0 and -0 is being compared
        // in the case of one list ending and the other having trailing zeros, both effective digits will be zero and so this if is not entered
        return false;
    }

    if (left == NULL && right == NULL) {
        // both lists exhausted and no inequality found; they must be equal
        return left_neg == right_neg || zero;
    }

    return lsp_list_num_equal_inner(left, right, zero, left_neg, right_neg);
}

bool lsp_list_num_equal(lsp_list_t* left, lsp_list_t* right) {
    // apparently, an empty list and a list containing a space character are not supposed to compare equal,
    // despite the project instructions strictly mentioning *number* equality and both are arguably zero
    // but who am i to argue
    if ((left->value == 0 && right->value != 0) || (right->value == 0 && left->value != 0)) {
        return false;
    }

    return lsp_list_num_equal_inner(left, right, true, false, false);
}

// todo: there has to be a cleaner way to do this...
bool lsp_list_num_lessthan_inner(lsp_list_t* left, lsp_list_t* right, bool tiebreak, bool eq, bool zero, bool left_neg, bool right_neg) {
    int effective_digit_left, effective_digit_right;
    effective_digit_left = lsp_list_effective_digit(&left);
    effective_digit_right = lsp_list_effective_digit(&right);
    left_neg = left_neg || effective_digit_left == '-' - '0';
    right_neg = right_neg || effective_digit_right == '-' - '0';

    // turn - into 0
    effective_digit_left = effective_digit_left < 0 ? 0 : effective_digit_left;
    effective_digit_right = effective_digit_right < 0 ? 0 : effective_digit_right;

    zero = zero && 0 == effective_digit_left && 0 == effective_digit_right;
    eq = eq && effective_digit_left == effective_digit_right;

    if (effective_digit_left < effective_digit_right) {
        tiebreak = true;
    }

    if (effective_digit_left > effective_digit_right) {
        tiebreak = false;
    }

    if (left == NULL && right == NULL) {
        // both lists exhausted; decide result
        // go off of signs first, then:
        // if both are negative, then invert tiebreak (and make sure they're not equal)
        // sorry about the xor trick >>'

        if (right_neg && !left_neg) return false;
        if (left_neg && !right_neg) return !zero;
        return (tiebreak ^ (left_neg && right_neg)) && !eq;
    }

    return lsp_list_num_lessthan_inner(left, right, tiebreak, eq, zero, left_neg, right_neg);
}

bool lsp_list_num_lessthan(lsp_list_t* left, lsp_list_t* right) {
    return lsp_list_num_lessthan_inner(left, right, false, true, true, false, false);
}

int sign(int n) {
    if (n > 0) return 1;
    if (n < 0) return -1;
    else return 0;
}

// this algorithm is probably weirder than what you'd find in other people's implementation of this, but i really wanted a catch-all function that would just do the thing every time
int lsp_list_num_add_first_stage(lsp_list_t* left, lsp_list_t* right, lsp_list_t* result, int carry, int sign_left, int sign_right) {
    /*
     * Basic operation of the first stage:
     * Add the numbers multiplied by sign and determine carry.
     * There are two types of carry:
     *     Additive/overflow carry - carry a 1 with the left-hand sign
     *     Subtractive/sign change carry - carry a 1 with the new sign (opposite of left-hand)
     * Sign change carry occurs when we would have to "borrow" from the column on the left in manual subtraction.
     * This algorithm will produce "degenerate" results (10^x - correct answer) when the sign of the final result does not align with the sign of the left operand.
     * The list produced by this algorithm is MSD-first, unlike the convention in the rest of the program.
     * Both are corrected in stage 2.
    */

    #ifdef NO_STOS
    if (left && right) printf("DEBUG START: le=%c ri=%c c=%d\n", left->value, right->value, carry);
    else printf("DEBUG START: le=NULL ri=NULL c=%d\n", carry);
    #endif
    // get effective digits of left and right operands with the correct sign
    bool should_return = left == NULL && right == NULL; // effective digit advances the list and we still want the logic to run to completion on the first full-empty column for carries
    int effective_digit_left, effective_digit_right;
    effective_digit_left = lsp_list_effective_digit(&left);
    effective_digit_right = lsp_list_effective_digit(&right);
    effective_digit_left = effective_digit_left < 0 ? 0 : effective_digit_left;
    effective_digit_right = effective_digit_right < 0 ? 0 : effective_digit_right;
    effective_digit_left *= sign_left;
    effective_digit_right *= sign_right;

    int new_digit_uncarried = effective_digit_left + effective_digit_right + carry;
    int new_digit;
    // check for sign change carry (ignore 0, no carry needed there)
    if (new_digit_uncarried != 0 && (sign(new_digit_uncarried) != sign_left)) {
        // sign change carry - digit to put in equals (sign_left)*10 + digit
        new_digit = abs(10*sign_left + new_digit_uncarried);
        carry = -sign_left;
    } else if (abs(new_digit_uncarried) >= 10) {
        // overflow carry
        new_digit = abs(-10*sign_left + new_digit_uncarried);
        carry = sign_left;
    } else {
        carry = 0;
        new_digit = abs(new_digit_uncarried);
    }

    #ifdef NO_STOS
    printf("DEBUG END: ele=%d eri=%d r_u=%d r=%d c'=%d\n", effective_digit_left, effective_digit_right, new_digit_uncarried, new_digit, carry);
    #endif
    lsp_list_push(result, '0' + new_digit);

    if (should_return) {
        // both lists exhausted, time to return
        // the result is degenerate if an unresolved carry occurs at the end
        // the value of the carry is the target sign if nonzero
        return carry;
    }

    return lsp_list_num_add_first_stage(left, right, result, carry, sign_left, sign_right);
    /* left_neg = left_neg || effective_digit_left == '-' - '0'; */
    /* right_neg = right_neg || effective_digit_right == '-' - '0'; */
}

int lsp_list_num_add_repair_degenerate(lsp_list_t* result) {
    int new_val = result->next == NULL ?
        (10 - result->value + '0')     :
        (10 - result->value + '0' - lsp_list_num_add_repair_degenerate(result->next));
    result->value = (new_val % 10) + '0';
    return !(new_val == 10);
}

void lsp_list_num_reverse_minimize_inner(lsp_list_t* result, lsp_list_t* final, bool ignore0) {
    // if zeros are not ignored or what's under result isn't zero or is the last element
    // (we don't want to create an empty list by accident)
    // push the digit onto the new list
    if (result->value == 0) return;
    char popped = lsp_list_pop(result);
    if (!(ignore0 && popped == '0')) {
        lsp_list_push(final, popped);
        ignore0 = false;
    }
    lsp_list_num_reverse_minimize_inner(result, final, ignore0);
}
lsp_list_t* lsp_list_num_reverse_minimize(lsp_list_t* result, int expected_sign) {
    lsp_list_t* final = lsp_list_new();
    if (expected_sign < 0) {
        lsp_list_push(final, '-');
    }
    lsp_list_num_reverse_minimize_inner(result, final, true);
    // correct a single - or empty list to a 0
    if ((final->value == '-' || final->value == '\0') && final->next == NULL) {
        final->value = '0';
    }
    lsp_list_destroy(result);
    return final;
}

lsp_list_t* lsp_list_num_add(lsp_list_t* left, lsp_list_t* right) {
    lsp_list_t* intermediate_list = lsp_list_new();
    int sign_left = lsp_list_end(left)->value == '-' ? -1 : 1;
    int sign_right = lsp_list_end(right)->value == '-' ? -1 : 1;
    int s1_status = lsp_list_num_add_first_stage(left, right, intermediate_list, 0, sign_left, sign_right);
    if (s1_status != 0) {
        lsp_list_num_add_repair_degenerate(intermediate_list);
    }
    return lsp_list_num_reverse_minimize(intermediate_list, s1_status == 0 ? sign_left : s1_status);
}
