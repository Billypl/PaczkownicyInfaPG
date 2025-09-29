#include <iostream>
using namespace std;
int tunoc() {
	static int a;
	a++;
	return a;
}
int main() {
	int a = 100;
	cout << tunoc() << endl;
	cout << tunoc() << endl;
	cout << a << endl;
	return 0;
}