#include <iostream>
using namespace std;
void tuc(char t[], int a) {
	t[a] = '\0';
}
int main() {
	char s[15] = "funkcjeWC";
	cout << sizeof s << endl;
	tuc(s, 3);
	cout << s[0] << endl;
	cout << sizeof s << endl;
	tuc(s, 5);
	cout << s << endl;
	return 0;
}