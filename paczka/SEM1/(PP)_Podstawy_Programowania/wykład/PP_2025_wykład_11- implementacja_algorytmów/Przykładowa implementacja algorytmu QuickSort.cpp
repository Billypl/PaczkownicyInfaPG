#include <stdio.h>

void zamien( int *t, int i1, int i2 ) {  // Funkcja zamienia miejscami
    int a = t[i1];                       // elementy o indeksach i1, i2
    t[i1] = t[i2];                       // w tablicy t.
    t[i2] = a;
}

/* Funkcja dokonuje podziału tablicy t, w którym element t[lewy] zostanie umieszczony pod
   indeksem granica, gdzie lewy <= granica <= prawy.  Ponadto, t[i] <= t[granica] dla
   wszystkich indeksów lewy <= i < granica, oraz t[j] >= t[granica] dla wszystkich
   indeksów granica < j <= prawy.*/
int podzial( int *t, int lewy, int prawy ) {
     int x = t[lewy], granica = lewy;
     zamien( t, lewy, prawy );
     for ( int i=lewy; i < prawy; i++ )
         if ( t[i] <= x )
	      zamien( t, i, granica++ );
     zamien( t, granica, prawy );
     return granica;
}

/* Funkcja sortująca `fragment' tablicy t pod indeksami lewy,...,prawy.
   Aby posortować tablicę A należy wywołać:
      QuickSort( A, 0, (sizeof A)/(sizeof A[0])-1 );  */
void QuickSort( int *t, int lewy, int prawy ) {
    if ( lewy < prawy ) {
        int granica = podzial( t, lewy, prawy );
	QuickSort( t, lewy, granica-1 );
	QuickSort( t, granica+1, prawy );
    }
}

int main() {
   int t[] = { 18,4,2,6,14,17,20,1,5,10,16,9,13,3,11,7,8,12,15,19 };
   QuickSort( t, 0, (sizeof t)/(sizeof t[0])-1 );
   for ( int i=0; i < (sizeof t)/(sizeof t[0]); i++ )
       printf( "%d,", t[i] );
   putchar( '\n' );
   return 0;
}
