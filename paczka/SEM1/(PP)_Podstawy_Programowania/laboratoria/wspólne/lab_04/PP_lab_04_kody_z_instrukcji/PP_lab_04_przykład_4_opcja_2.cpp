#include<iostream>

#define SIZE 15
using namespace std;

int main(){
	char tab[SIZE][SIZE+1];
	int i, j;
	for(i = 0; i < SIZE; i++){
		for(j = 0; j < SIZE; j++)
			tab[i][j] = (i == j) || (i + j == SIZE - 1) ? '*' : ' ';
		tab[i][j] = '\0';
	}
	for(i = 0; i < SIZE; i++)
		cout << tab[i] << endl;
	return 0;
}
