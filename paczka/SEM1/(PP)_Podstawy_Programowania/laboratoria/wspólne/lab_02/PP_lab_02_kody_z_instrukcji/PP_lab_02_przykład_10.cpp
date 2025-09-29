#include <iostream>
using namespace std;
int main() {
    int sizeX = 10;
    int sizeY = 20;
    for (int i = 0; i < sizeY; ++i) {
        for (int j = 0; j < sizeX; ++j) {
            if (i == 0 || i == sizeY - 1 || j == 0 || j == sizeX - 1) {
                cout << '*';
            } else {
                cout << ' ';
            }
        }
        cout << endl;
    }
    return 0;
}
