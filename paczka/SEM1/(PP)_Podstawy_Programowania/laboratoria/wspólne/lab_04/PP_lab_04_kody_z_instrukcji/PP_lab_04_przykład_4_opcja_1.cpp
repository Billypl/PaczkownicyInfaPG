#include<iostream>

#define SIZE 15
using namespace std;

int main(){
	char tab[SIZE][SIZE];
	int i, j;
	for(i = 0; i < SIZE; i++){
		for(j = 0; j < SIZE; j++)
			if(i == j) tab[i][j] = '*';
			else tab[i][j] = ' ';
	}
	for(i = SIZE - 1, j = 0; j < SIZE; i--, j++)
		tab[i][j] = '*';
	for(i = 0; i < SIZE; i++){
		for(j = 0; j < SIZE; j++) 
			cout << tab[i][j];
		cout << endl;
	}
	return 0;
}
