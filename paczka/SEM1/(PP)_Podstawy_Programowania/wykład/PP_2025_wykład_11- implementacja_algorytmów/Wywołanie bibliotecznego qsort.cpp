#include <stdio.h>
#include <stdlib.h>

int cmp (const void * a, const void *b) {
    return  *(int*)a  -  *(int*)b;

    /* Por�wnaj:
    int _va = *(int*)a;
    int _vb = *(int*)b;

    if (_va > _vb) return 1;
    if (_va < _vb) return -1;
    return 0; 
    */
}

int main() {
    int t[] = { 6, 34, 21, 43, 34, 1, 0, 23, 12, 22 };

    qsort ((void*) t, (sizeof t)/(sizeof t[0]), sizeof(int), cmp);

    for (int i=0; i<(sizeof t)/(sizeof t[0]); i++)
        printf ("%d ", t[i]);
    putchar( '\n' );
    return 0;
}
