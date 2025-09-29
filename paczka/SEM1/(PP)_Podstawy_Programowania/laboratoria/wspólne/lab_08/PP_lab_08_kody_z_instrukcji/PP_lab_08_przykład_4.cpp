#include <iostream>
using namespace std;
struct punkt {
    double x;
    double y;
};
int wypisz(punkt *wskp) {
    cout << wskp->x << " " << wskp->y << endl;
    return 0;
}
int wypisztab(punkt *wskp, int liczba) {
    for (punkt *temp = wskp; temp < wskp + liczba; temp++)
        wypisz(temp);
    return 0;
}
int main() {
    punkt *tab;
    tab = new punkt[3];
    tab[0].x = tab[0].y = 0;
    (*(tab + 1)).x = 1;
    (*(tab + 1)).y = 2;
    (tab + 2)->x = 4;
    (tab + 2)->y = 6.5;
    wypisztab(tab, 3);
    delete[] tab;
    return 0;
}
