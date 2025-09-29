#include <iostream>
using namespace std;
int fibo(unsigned int n) {
    int f0 = 0, f1 = 1, wynik;
    if (n == 0)
        return f0;
    if (n == 1)
        return f1;
    for (int i = 2; i <= n; i++) {
        wynik = f0 + f1;
        f0 = f1;
        f1 = wynik;
    }
    return wynik;
}
int main(int argc, char *argv[]) {
    unsigned int nr;
    cin >> nr;
    cout << fibo(nr) << endl;
}
