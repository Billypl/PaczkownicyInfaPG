#include <iostream>
using namespace std;
int main() {
    int x;
    cin >> x;
    int exp = 0;
    int rem = x;
    while (rem % 2 == 0) {
        rem >>= 1;
        exp++;
    }
    if (exp > 0) {
        cout << x << "=" << "2ˆ" << exp;
        if (rem > 1)
            cout << "∗" << rem;
    } else {
        cout << x << "toliczbanieparzysta" << endl;
    }
    return 0;
}
