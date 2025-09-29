#include<iostream>
using namespace std;
#define MAX_DLUGOSC 16
int wypisz_slowa(char slowa[][MAX_DLUGOSC], int il_slow)
{
	int i;
	for(i=0;i<il_slow;i++)
		cout <<i<<": "<< slowa[i]<<endl;
	return 0;
}

int main()
{	char tab[] = "Slowo";
	char tab2[][MAX_DLUGOSC] = {"Pierwsze","Drugie","Trzecie"};
	wypisz_slowa(tab2, sizeof(tab2)/sizeof(tab2[0]));
}
