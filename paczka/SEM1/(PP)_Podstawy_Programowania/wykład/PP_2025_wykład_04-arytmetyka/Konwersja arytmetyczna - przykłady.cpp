#include <iostream>
using namespace std;
/* Program ilustrujący potencjalne
 kłopoty związane z konwersją typów
 (zaokrąglenia) */
int main() {
  double d = 1/3; // dzielenie całkowitoliczbowe!
  int i = 1/3;
  
  cout << i << endl;
  cout << d << endl;
  d = 1/3.0; // operandy zmiennoprzecinkowe
  cout << d << endl;
  d = (1.0F)/3; // operandy zmiennoprzecinkowe
  cout << d << endl; // j.w.
  // Uwaga: dwa poniższe wyrażenia dają
  // inne wyniki. Powód: opracowywanie
  // wyrażenia "od lewej do prawej"
  d = 27/2/2.0;
  cout << d << endl;
  d = 27.0/2/2;
  cout << d << endl;
  return 0;
}