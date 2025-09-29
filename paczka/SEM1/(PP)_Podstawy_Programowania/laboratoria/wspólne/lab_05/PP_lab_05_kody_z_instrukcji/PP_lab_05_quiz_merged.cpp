#include <iostream>
using namespace std;
int xent(int a) {
	return ++a;
}
int main_next() {
	int a = 0;
	cout << xent(a) << endl;
	cout << xent(xent(a)) << endl;
	cout << a << endl;
	return 0;
}

int tunoc() {
	static int a;
	a++;
	return a;
}
int main_count() {
	int a = 100;
	cout << tunoc() << endl;
	cout << tunoc() << endl;
	cout << a << endl;
	return 0;
}

void waps(char t[], int i, int j) {
	t[i] ^= t[j];
	t[j] ^= t[i];
	t[i] ^= t[j];	
}
void vin(char t[], int a) {
	int i = 0;
	char c;
	while (i<a/2) {
		waps(t, i, a - i - 1);
		i++;
	}
}
int main_inv() {
	char t[] = "A NA KEI ZDUNA FELA";
	vin(t, (sizeof t) - 1);
	cout << t << endl;
	return 0;
}

void tuc(char t[], int a) {
	t[a] = '\0';
}
int main_cut() {
	char s[15] = "funkcjeWC";
	cout << sizeof s << endl;
	tuc(s, 3);
	cout << s << endl;
	cout << sizeof s << endl;
	tuc(s, 5);
	cout << s << endl;
	return 0;
}

int main_args(int argc, char* argv[]) {
	char t[] = "AB";
	cout << argc << endl;
	cout << t << endl;
	t[1] = t[0];
	if (argc >= 0) main_args(-1, NULL);
	return 0;
}

int* cnierp(int *a) {
	(*a)++;
	return a;
}
int cnitsop(int *a) {
	return (*a)++;
}
int main_inc() {
	int a = 10;
	cout << *cnierp(&a) << endl;
	cout << cnitsop(&a) << endl;
	cout << a << endl;
	return 0;
}

int main(int argc, char* argv[]) {
	cout << endl << "main_args" << endl;
	main_args(argc, argv);
	cout << endl << "main_next" << endl;
	main_next();
	cout << endl << "main_count" << endl;
	main_count();
	cout << endl << "main_cut" << endl;
	main_cut();
	cout << endl << "main_inv" << endl;
	main_inv();
	cout << endl << "main_inc" << endl;
	main_inc();
	return 0;
}