#include <iostream>
using namespace std;
int main() {
    int x = 5;
    int *pi = &x;
    int y = x;
    *pi = 6;
    cout << x << "" << y << endl;
    return 0;
}
