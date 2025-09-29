#include<iostream>
#include<stdlib.h>
#include<time.h>

using namespace std;

/** Funkcja losuje n liczb zmiennoprzecinowych z przedzia≥u <-1000,1000>
 *   do tablicy pod wskaünikiem tab.
 *  Tablica powinna mieÊ juø przydzielona pamiec.
 *  Funkcja zwraca wskaünik do wylowosanej tablicy.
 */
double *losuj(double *tab, int n){
	for(int i = 0; i < n; i++)
		tab[i] = (rand()%2?1:-1)*(rand()%1000+(double)rand()/RAND_MAX); 
	return tab;
}

/** Funkcja wypisuje n liczb zmiennoprzecinowych z tablicy tab.
 */
void wypisz(double *tab, int n){
	while(n--)
		cout << *tab++ << " ";
	cout << endl;
}

int main(){
	int wielkosc;
	double *liczby = NULL;
	srand(time(NULL));
	for(int i = 1; i < 10; i++){
		wielkosc = rand()%1001 + 1000;	// losowanie wielkosci tablicy z przedzialu <1000,2000>
		liczby = new double[wielkosc];
		wypisz(losuj(liczby,wielkosc),wielkosc);
		getchar();
	}
	return 0;
}
