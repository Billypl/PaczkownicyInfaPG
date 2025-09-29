#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;
struct osoba{
	char nick[10];
	char email[30];
	struct osoba *partner;
};
void wypisz(struct osoba *a){
	if (a == NULL)
		cout << "Pusty rekord\n";
	else
		cout << a->nick << '\t' << a->email;
	if (a->partner != NULL)
		cout << '\t' << a->partner->nick << '\n';
	else
		cout << '\n';
}
void wypisz_wszystkie(struct osoba *tab, int n){
	for (int i = 0; i < n; ++i, ++tab)
		wypisz(tab);
}
bool losowanie(struct osoba *tab, int n){
	if (n % 2 == 0){
		struct osoba *parowany = tab;
		for (int i = 0; i < n / 2; ++i){
			struct osoba *temp;
			while (parowany->partner != NULL)//szukanie niesparowanego
				++parowany;
			//Losowanie, który nastêpny nieprzydzielony sprarowaæ
			int los = rand() % (n - 2 * i - 1) + 1;
			temp = parowany;
			while (los > 0){//szukanie niesparowanego odleg³ego o los
				++temp;
				if (temp->partner == NULL) los--;
			}
			//parowanie
			parowany->partner = temp;
			temp->partner = parowany;
		}
		return true;
	}
	else
		return false;
}
int main()
{
	struct osoba tab[4] = { { "Olo", "alek@qwer.eu", NULL }, \
	{"zuza", "zuz@sp3.gda.pl", NULL}, \
	{"Misiu", "sos@sp3.gda.pl", NULL}, \
	{"Bolo", "bloleslaw1990@wwpp.pl", NULL} };
	srand(time(NULL));
	losowanie(tab, 4);
	wypisz_wszystkie(tab, 4);
	return 0;
}
