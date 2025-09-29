#include <iostream>
using namespace std;

/* Ilustracja działania instrukcji
   break w zagnieższonej pętli.*/
int main() {
    int i, j;

    for ( i=1; i <= 10; i+=1 ) {
       for ( j=1; j <= 10; j+=1 ) {
          if ( i + j >= 10 )
	     break;
          cout << j << ' ';
       }
       cout << endl;  
    }
    return 0;
}