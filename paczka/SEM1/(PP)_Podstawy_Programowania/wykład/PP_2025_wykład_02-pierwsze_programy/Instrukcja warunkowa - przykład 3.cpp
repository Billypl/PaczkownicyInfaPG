#include <iostream>
using namespace std;

/* Program ilustrujący użycie instrukcji warunkowej */
int main() {
    int liczba1, liczba2;
    
    cin >> liczba1;
    cin >> liczba2;    
    
    if ( liczba2 != liczba1 )
        cout << "liczba1 jest różna od liczba2\n";
    else
        cout << "liczba1 == liczba2\n";
    return 0;
}