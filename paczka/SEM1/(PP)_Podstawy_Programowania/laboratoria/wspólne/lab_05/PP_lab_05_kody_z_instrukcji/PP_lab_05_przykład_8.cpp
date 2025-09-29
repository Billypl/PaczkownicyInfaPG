#include <iostream>
#include <stdlib.h> /* srand, rand */
#include <time.h>   /* time */
using namespace std;
int main() {
    const int max_rand = 10;
    const int it_num = 10;
    cout << "Bez srand():" << endl;
    for (int i = 0; i < it_num; i++)
        cout << rand() % max_rand << endl;
    cout << "Ze srand():" << endl;
    srand(time(NULL));
    for (int i = 0; i < it_num; i++)
        cout << rand() % max_rand << endl;
}
