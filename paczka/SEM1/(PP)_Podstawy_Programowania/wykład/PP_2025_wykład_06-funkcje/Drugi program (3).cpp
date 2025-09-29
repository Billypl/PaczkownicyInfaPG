/* dyrektywy preprocesora: włączenie plików nagłówkowych */
#include <iostream>
#include <math.h>
using namespace std;

/* definicja funkcji main, zwracającej wartość całkowitą */ 
int main () {
	/* deklaracja zmiennych */
	double a, b;

	cout << "Podaj długości boków prostokąta\n";
	cin >> a;
	cin >> b;
	/* instrukcja przypisania, operacje arytmetyczne, wywołanie funkcji bibliotecznej */ 
	double c = sqrt(a*a + b*b);
	cout << "Długość przekątnej prostokąta wynosi: ";
	cout << c << '\n';
	return 0;  /* wartość zwracana typu całkowitego */
}
