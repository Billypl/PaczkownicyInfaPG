#include <iostream>
#include <stdlib.h>
#include <time.h>

#define SIZE 250

using namespace std;

int main() {
    const double ratings[] = {2, 3, 3.5, 4, 4.5, 5, 5.5};
    int results[SIZE], stat[7] = {}, i;
    srand(time(NULL));
    for (i = 0; i < SIZE; i++)
        results[i] = rand() % 7; // drawing rating index
    for (i = 0; i < SIZE; i++)
        stat[results[i]]++;

    for (i = 0; i < 7; i++)
        cout << ratings[i] << " - " << stat[i] << endl;
    return 0;
}
