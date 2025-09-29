#include <iostream>
using namespace std;
int main(int argc, char *argv[]) {
    char t[] = "AB";
    cout << argc << endl;
    cout << t << endl;
    t[1] = t[0];
    if (argc >= 0)
        main(-1, NULL);
    return 0;
}
