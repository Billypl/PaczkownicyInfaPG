#include <iostream>
using namespace std;
int main() {
    int i = 7;
    while (i--) // brzydko,
        // zapis i>0 lepiej
        // oddaje intencję programisty
        cout << "Witaj przyjacielu" << endl;
    // brak nawiasów zmniejsza czytelność
    // i sprzyja powstawaniu błędów
    // przy późniejszych modyfikacjach
    return 0;
}
