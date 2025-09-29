#include <iostream>
using namespace std;

int max2(int a, int b); // nag³ówek funkcji max2

int main(int argc, char *argv[]) {
    int k, l, max;
    cin >> k;
    cin >> l;
    max = max2(k, l);
    cout << max << endl;
    return 0;
}
int max2(int a, int b) {
    if (a > b)
        return a;
    return b;
}
