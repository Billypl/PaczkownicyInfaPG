#include <iostream>
using namespace std;

/* wypisanie liczb podzielnych przez 3 z zakresu [1,n],
   gdzie n jest wartością podaną przez użytkownika
   --- wersja błędna!! */
int main() {
    int n, i=3;

    cin >> n;
    while ( i <= n ) {
       if ( i % 3 == 0 )
          cout << i;
    }
    return 0;
}