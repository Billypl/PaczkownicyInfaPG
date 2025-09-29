#include <iostream>
using namespace std;

int main() {
    wchar_t text[] = L"ą|ę|ł|\u0413" setlocale(LC_ALL, "");
    wcout << text << endl;
    for (int i = 0; text[i]; i++)
        wcout << (int)text[i] << ' ';
    wcout << endl;
    return 0;
};
