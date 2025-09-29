#include <iostream>
using namespace std;
int pewna_silnia(int n) {
    int wynik = 1;
    for (int i = n; i > 0; i -= 2)
        wynik *= i;
    return wynik;
}
int main() {
    int n, s;
    cout << "Podaj n: ";
    cin >> n;
    s = pewna_silnia(n);
    cout << "Wynik: " << s;
    return 0;
}
