#include <iostream>
using namespace std;
int main() {
    int size = 13;
    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            if (i == j || i == size - j - 1) {
                cout << '*';
            } else {
                cout << ' ';
            }
        }
        cout << endl;
    }
    return 0;
}
