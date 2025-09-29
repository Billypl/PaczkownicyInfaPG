#include <iostream>
using namespace std;
int main(int argc, char *argv[]) {
    cout << "argc:\t\t" << argc << endl;
    for (int i = 0; i < argc; i++) {
        cout << "argv[" << i << "]:\t" << argv[i] << endl;
    }
    return 0;
}
