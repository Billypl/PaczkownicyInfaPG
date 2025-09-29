#include <iostream>
using namespace std;

/* wypisanie liczb podzielnych przez 3 z zakresu [1,n],
   gdzie n jest wartością podaną przez użytkownika.*/
int main() {
    int n, i;

    cin >> n;
    for ( i=3; i <= n; i+=1 )
       if ( i % 3 == 0 )
          cout << i << endl;
    return 0;
}
