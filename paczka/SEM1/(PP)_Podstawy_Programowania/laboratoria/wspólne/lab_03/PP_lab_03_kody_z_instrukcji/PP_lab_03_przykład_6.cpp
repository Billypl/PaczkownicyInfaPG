#include <iostream>
using namespace std;
int main() {
    double x = 0.3;
    x = x - 0.1;
    x = x - 0.1;
    x = x - 0.1;
    if (x == 0)
        cout << "zero" << endl;
    else
        cout << "nie zero" << endl;
    cout << x << endl;
    return 0;
}
