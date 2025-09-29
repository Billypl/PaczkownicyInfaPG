#include <iostream>
using namespace std;

void Rekurencja(int p) {
    cout << "zaczyna sie wywolanie Rekurencja(" << p << ")" << endl;
    if (p == 0) {
        cout << "return z wywolania Rekurencja(" << p << ")" << endl;
        return;
    };
    Rekurencja(p - 1);
    cout << "konczy sie wywolanie Rekurencja(" << p << ")" << endl;
};

int main() {
    Rekurencja(3);
    return 0;
};
