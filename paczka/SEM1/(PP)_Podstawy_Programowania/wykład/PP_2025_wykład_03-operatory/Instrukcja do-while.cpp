#include <iostream>
using namespace std;

/* wypisanie liczb podzielnych przez 3 z zakresu [1,n],
   gdzie n jest wartością podaną przez użytkownika.*/
int main() {
    int n, i=3;

    cin >> n;
    if ( n < 3 )
      return 0;
    do {
       if ( i % 3 == 0 )
          cout << i << endl;
       i = i+1;
    } while ( i <= n );
    return 0;
}
