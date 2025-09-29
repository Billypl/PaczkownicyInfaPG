#include <iostream>
using namespace std;
int main() {
    int sizeX = 10;
    int sizeY = 20;
    for (int j = 0; j < sizeX; ++j) {
        cout << '*';
    }
    cout << endl;
    for (int i = 1; i < sizeY - 1; ++i) {
        cout << '*';
        for (int j = 1; j < sizeX - 1; ++j) {
            cout << ' ';
        }
        cout << '*' << endl;
    }
    for (int j = 0; j < sizeX; ++j) {
        cout << '*';
    }
    cout << endl;
    return 0;
}
