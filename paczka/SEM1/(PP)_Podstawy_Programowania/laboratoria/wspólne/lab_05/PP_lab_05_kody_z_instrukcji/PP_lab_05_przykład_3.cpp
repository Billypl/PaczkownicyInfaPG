#include <iostream>
using namespace std;

int dlugosc(char lan[]) {
    int dlugosc = 0;
    while (lan[dlugosc] != NULL)
        dlugosc++;
    return dlugosc;
}
int main(int argc, char *argv[]) {
    cout << "argc:\t\t" << argc << endl;
    for (int i = 0; i < argc; i++) {
        int d = dlugosc(argv[i]);
        cout << "dlugosc(argv[" << i << "]):\t" << d << endl;
    }
    return 0;
}
