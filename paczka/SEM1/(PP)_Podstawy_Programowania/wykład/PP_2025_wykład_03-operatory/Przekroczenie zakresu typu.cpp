#include <iostream>
using namespace std;

/* Program ilustrujący przekroczenie zakresu typu */
int main() {
  short s;
  unsigned int ui = 0;
  
  s = 128*256;
  cout << s << endl;
  
  ui = ui-1;
  cout << ui << endl;
  return 0;
}
