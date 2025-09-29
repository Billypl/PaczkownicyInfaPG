#include <iostream>
using namespace std;
void waps(char t[], int i, int j) {
	t[i] ^= t[j];
	t[j] ^= t[i];
	t[i] ^= t[j];	
}
void vin(char t[], int a) {
	int i = 0;
	while (i<a/2) {
		waps(t, i, a - i - 1);
		i++;
	}
}
int main() {
	char t[] = "A NA KEI ZDUNA FELA";
	vin(t, (sizeof t) - 1);
	cout << t << endl;
	return 0;
}