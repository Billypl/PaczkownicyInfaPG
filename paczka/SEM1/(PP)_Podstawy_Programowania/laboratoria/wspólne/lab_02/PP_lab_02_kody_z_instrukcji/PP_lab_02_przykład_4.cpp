#include <iostream>
using namespace std;
int main() {
    double x;
    double y;
    cout << "Ten program dodaje dwie liczby." << endl;
    cout << "Podaj liczbe 1:";
    if (cin >> x) {
        cout << "Podaj liczbe 2:";
        if (cin >> y) {
            cout << x << "+" << y << "=" << (x + y) << endl;
        } else {
            cout << "niepoprawne dane" << endl;
        }
    } else {
        cout << "niepoprawne dane" << endl;
    }
    cout << "koniec." << endl;
    return 0;
}
