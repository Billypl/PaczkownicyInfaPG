#include <iostream>
using namespace std;
int main() {
    unsigned char x;
    x = 16;
    x = x * x;
    cout << (int)x << endl; // 0
    unsigned char y;
    y = 16;
    cout << (int)(y * y) << endl; // 256
    return 0;
}
