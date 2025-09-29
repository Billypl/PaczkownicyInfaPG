#include <stdio.h>
#include <time.h>

// oczekiwanie na reakcjê u¿ytkownika
void CzekajNaEnter() {
    printf("nacisnij Enter\n");
    getchar();
};

// zatrzymanie programu na czas sekund
void Czekaj(double czas) {
    int t;
    t = clock();
    while ((clock() - t) < czas * CLOCKS_PER_SEC) {
        /* pass */
    };
};

int main() {
    printf("0123456789 -- tabulator\n");
    printf("\t*\n");
    printf("0\t*\n");
    printf("01\t*\n");
    printf("012\t*\n");
    printf("0123\t*\n");
    printf("01234\t*\n");
    printf("012345\t*\n");
    printf("0123456\t*\n");
    printf("01234567\t*\n");
    printf("012345678\t*\n");
    printf("0123456789\t*\n");
    printf("0123456789A\t*\n");
    CzekajNaEnter();

    char *imiona[] = {"Ala", "Ela", "Ola", "Ula", "Bolek", "Lolek", "Reksio"};
    int wyniki[] = {10, 40, 20, 30, 20, 0, 40};
    printf("+-------+-------+-------+\n");
    printf("|imie\t|punkty\t|[%%]\t|\n");
    printf("+-------+-------+-------+\n");
    for (int i = 0; i < sizeof(imiona) / sizeof(imiona[0]); ++i) {
        printf("|%s\t|%d\t|%d\t|\n", imiona[i], wyniki[i], wyniki[i] * 5 / 2);
    };
    printf("+-------+-------+-------+\n");
    CzekajNaEnter();

    printf("stary napis, nowa linia na koncu\n");
    printf("nowy napis\n");
    printf("----------\n");
    printf("stary napis, powrot karetki na koncu\r");
    printf("nowy napis\n");
    printf("----------\n");
    CzekajNaEnter();

    printf("obliczanie: ");
    for (int i = 0; i <= 100; i++) {
        Czekaj(0.1);
        printf("%3d%%\b\b\b\b", i);
    };
    printf("\n");
    CzekajNaEnter();

    for (int i = 0; i <= 100; i++) {
        Czekaj(0.1);
        printf("obliczanie drugie: %3d%%\r", i);
    };
    printf("\n");

    return 0;
};
