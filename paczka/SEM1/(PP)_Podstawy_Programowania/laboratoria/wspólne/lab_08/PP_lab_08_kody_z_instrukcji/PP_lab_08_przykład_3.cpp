#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;
void losuj(int *n, int **tab){
	*n = rand() % 10 + 1;
	*tab = new int[*n];
	for (int i = 0; i < *n; ++i)
		(*tab)[i] = rand() % 100;
}
void wypisz(int n, int *tab){
	for (; n--; ++tab)
		cout << *tab << ' ';
	cout << endl;
}
int main()
{
	int n, *wsk;
	srand(time(NULL));
	losuj(&n, &wsk);
	wypisz(n, wsk);
	delete[] wsk;
	return 0;
}
