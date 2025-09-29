#include <stdio.h>
#include <stdlib.h>

// Przypisanie konkretnej wartości identyfikatorowi TEST nie jest tutaj konieczne.
#define TEST

int cmp (const void * a, const void *b) {
   #ifndef TEST
      int a1 = *(int*)a, b1 = *(int*)b;
      printf( " %d %c %d\n", a1, (a1==b1 ? '=' : (a1>b1 ? '>' : '<') ), b1 );
   #endif
   return  *(int*)a  -  *(int*)b;
}

int main() {
   int t[] = { 6, 34, 21, 43, 34, 1, 0, 23, 12, 22 };

   qsort( (void*)t, (sizeof t)/(sizeof t[0]), sizeof(int), cmp);

   for (int i=0; i<(sizeof t)/(sizeof t[0]); i++)
      printf ("%d ", t[i]);
   putchar( '\n' );
   return 0;
}
