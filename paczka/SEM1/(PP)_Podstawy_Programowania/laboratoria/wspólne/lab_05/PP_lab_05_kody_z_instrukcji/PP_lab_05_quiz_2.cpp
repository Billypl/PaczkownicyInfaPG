#include <iostream>
using namespace std;
int xent(int a) {
	return ++a;
}
int main() {
	int a = 0;
	cout << xent(a) << endl;
	cout << xent(xent(a)) << endl;
	cout << a << endl;
	return 0;
}