#include <iostream>
using namespace std;
int* cnierp(int *a) {
	(*a)++;
	return a;
}
int cnitsop(int *a) {
	return (*a)++;
}
int main() {
	int a = 10;
	cout << *cnierp(&a) << endl;
	cout << cnitsop(&a) << endl;
	cout << a << endl;
	return 0;
}