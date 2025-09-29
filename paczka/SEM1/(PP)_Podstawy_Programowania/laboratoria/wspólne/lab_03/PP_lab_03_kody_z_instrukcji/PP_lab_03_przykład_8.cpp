#include <iostream>
using namespace std;
int main() {
    int x = 5;
    int *pi1 = &x;
    int *pi2 = &x;
    cout << *pi1 << "" << *pi2 << endl;
    x = 6;
    cout << *pi1 << "" << *pi2 << endl;
    return 0;
}
