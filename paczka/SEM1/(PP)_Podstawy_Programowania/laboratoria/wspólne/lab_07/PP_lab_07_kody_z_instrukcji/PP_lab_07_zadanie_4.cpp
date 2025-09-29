#include <stdio.h>

int main() {
    FILE *pl;
    pl = fopen("plik.txt", "wb");
    fprintf(pl, "napis");
    getchar();
    fclose(pl);
    return 0;
};
