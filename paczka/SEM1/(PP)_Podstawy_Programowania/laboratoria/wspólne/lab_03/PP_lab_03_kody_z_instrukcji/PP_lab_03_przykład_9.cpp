#include <iostream>
using namespace std;
int main() {
    int x = 5;
    int *pi = &x;
    int **ppi = &pi;
    int y = x;
    *ppi = &y;
    *pi = 6;
    **ppi = 7;
    cout << x << "" << y << endl;
    return 0;
}
