#include <iostream>
using namespace std;
int main() {
    int size = 11;
    // gorne V
    for (int i = 0; i < size / 2; ++i) {
        for (int j = 0; j < i; ++j) {
            cout << ' ';
        }
        cout << '*';
        for (int j = 0; j < size - 2 * i - 2; ++j) {
            cout << ' ';
        }
        cout << '*';
        for (int j = 0; j < size; ++j) {
            cout << ' ';
        }
        cout << endl;
    }
    // srodkowy wiersz
    if (size % 2 == 1) {
        for (int j = 0; j < size / 2; ++j) {
            cout << ' ';
        }
        cout << '*';
        for (int j = 0; j < size / 2; ++j) {
            cout << ' ';
        }
        cout << endl;
    }
    // odwrocone V
    for (int i = 0; i < size / 2; ++i) {
        for (int j = 0; j < size / 2 - i - 1; ++j) {
            cout << ' ';
        }
        cout << '*';
        for (int j = 0; j < 2 * i + size % 2; ++j) {
            cout << ' ';
        }
        cout << '*';
        for (int j = 0; j < size / 2 - i - 1; ++j) {
            cout << ' ';
        }
        cout << endl;
    }
    return 0;
}
