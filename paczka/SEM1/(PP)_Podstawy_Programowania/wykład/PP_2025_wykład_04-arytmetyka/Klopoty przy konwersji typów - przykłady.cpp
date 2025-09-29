#include <iostream>
using namespace std;
/* Program ilustrujący potencjalne
 kłopoty związane z konwersją typów */
int main() {
  int a = -1;
  unsigned int b = 1;
  short c=100;
  long long l;
  char znak = '0';
  
  cout << (unsigned) a << endl;
  cout << (a < b) << endl;      // niejawna konwersja a do typu unsigned int
  cout << a+1 << endl;       // wszystko dobrze (oba operandy typu int)
  cout << a+ (unsigned int)1 << endl;  // wszystko dobrze... przypadkiem  
  a = -2;
  cout << a+ (unsigned int)1 << endl; // niejawna konwersja a do unsigned int
  cout << c*c*c*c << endl; // wszystko dobrze: mnożenie po konwersji do int
  l = ((long long)1)<<35;  // wszystko dobrze
  cout << l << endl;
  l = 1<<35; // możliwy błąd gdy int jest 32-bit. Kompilator może ostrzegać!
  cout << l << endl;
  cout << znak << endl; // wypisujemy znak
  cout << (int) znak << endl; // oraz jego kod ASCII
  return 0;
}