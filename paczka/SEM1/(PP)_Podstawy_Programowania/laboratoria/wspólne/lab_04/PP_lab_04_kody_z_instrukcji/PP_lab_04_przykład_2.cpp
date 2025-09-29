#include <iostream>

#define SIZE 6

using namespace std;

int main() {
    int tab1[SIZE], tab2[SIZE], join[2 * SIZE], i, j, k;

    for (i = 0; i < SIZE; i++)
        cin >> tab1[i];
    for (i = 0; i < SIZE; i++)
        cin >> tab2[i];
    for (i = 0, j = 0, k = 0; k < 2 * SIZE; k++) {
        if (k % 2 == 0) {
            join[k] = tab1[i];
            i++;
        } else {
            join[k] = tab2[j];
            j++;
        }
    }
    for (k = 0; k < 2 * SIZE; k++)
        cout << join[k] << " ";
    return 0;
}
