#include <iostream>
using namespace std;
/* Program ilustrujący reprezentację binarną liczby typu int */
int main() {
   int a = -1, b;

   for (b=8*sizeof(int)-1; b>=0; b--)
      cout << ((a & (1U<<b)) > 0);
   cout << endl;

   a = 13;
   for (b=8*sizeof(int)-1; b>=0; b--)
      cout << ((a & (1U<<b)) > 0);
   cout << endl;

   return 0;
}
