#include <iostream>
using namespace std;
int main() { /* Uwaga: endl powoduje wypisanie znaku \n na ekran */
  cout << "Rozmiar typu char: " << sizeof(char) << endl;
  cout << "Rozmiar typu short: " << sizeof(short) << endl;
  cout << "Rozmiar typu int: " << sizeof(int) << endl;
  cout << "Rozmiar typu long: " << sizeof(long) << endl;
  cout << "Rozmiar typu long long: " << sizeof(long long) << endl;
  cout << "Rozmiar typu float: " << sizeof(float) << endl;
  cout << "Rozmiar typu double: " << sizeof(double) << endl;
  cout << "Rozmiar typu long double: " << sizeof(long double) << endl;
  return 0;
}
