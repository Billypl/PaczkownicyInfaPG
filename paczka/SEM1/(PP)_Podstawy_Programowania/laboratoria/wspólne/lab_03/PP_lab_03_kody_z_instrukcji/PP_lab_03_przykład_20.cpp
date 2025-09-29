#include <iostream>
using namespace std;
int main() {
    int samogloski = 0;
    int biale = 0;
    int inne = 0;
    int cyfry = 0;
    char z;
    while (cin >> noskipws >> z) {
        switch (z) {
        case 'a':
        case 'e':
        case 'i':
        case 'o':
        case 'u':
        case 'y':
        case 'A':
        case 'E':
        case 'I':
        case 'O':
        case 'U':
        case 'Y':
            samogloski++;
            break;
        case ' ':
        case '\t':
        case '\n':
            biale++;
            break;
        default:
            if (z >= '0' && z <= '9')
                cyfry++;
            else
                inne++;
        }
    }
    cout << "Wczytano" << endl;
    cout << "-samoglosek:" << samogloski << endl;
    cout << "-cyfr:" << cyfry << endl;
    cout << "-bialychznakow:" << biale << endl;
    cout << "-pozostalych:" << inne << endl;
    cout << "*******************" << endl;
    return 0;
}
