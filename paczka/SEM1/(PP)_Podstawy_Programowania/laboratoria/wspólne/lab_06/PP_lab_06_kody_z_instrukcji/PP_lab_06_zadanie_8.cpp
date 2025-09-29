#include <iostream>
using namespace std;
int Fibonacci(int n, int poziom) {
    int i, wynik;
    for (i = 0; i < poziom - 1; i++)
        cout << "|";
    if (poziom > 0)
        cout << "+->";
    cout << "obliczamyFibonacci(" << n << ")" << endl;
    if (n <= 1) {
        for (i = 0; i < poziom - 1; i++)
            cout << "|";
        if (poziom > 0)
            cout << "+->";
        cout << "Fibonacci(" << n << ")=1" << endl;
        return 1;
    };
    wynik = Fibonacci(n - 1, poziom + 1) + Fibonacci(n - 2, poziom + 1);
    for (i = 0; i < poziom - 1; i++)
        cout << "|";
    if (poziom > 0)
        cout << "+->";
    cout << "Fibonacci(" << n << ")=" << wynik << endl;
    return wynik;
};
int main() {
    Fibonacci(5, 0);
    return 0;
};
