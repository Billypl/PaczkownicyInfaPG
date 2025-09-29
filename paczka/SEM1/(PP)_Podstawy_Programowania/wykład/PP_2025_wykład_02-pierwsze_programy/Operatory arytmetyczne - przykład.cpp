#include <iostream>
using namespace std;

/* Program ilustrujący operatory arytmetyczne */
int main() {
  int a = 10, b = 7;

  b = (a++) % b;
  cout << "a=" << a << ",b=" << b << endl;   /*a=11,b=3*/
  cout << "a=" << a << ",b=" << b++ << endl; /*a=11,b=3*/
  cout << "a=" << --a << ",b=" << b << endl; /*a=10,b=4*/
  a = 7/10;
  b = 7/2;
  cout << "a=" << a << ",b=" << b << endl; /*a=0,b=3*/
  
  return 0;
}