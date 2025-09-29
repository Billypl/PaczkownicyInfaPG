#include<iostream>
using namespace std;
int main ( )
{
    double tablica [10] = { 1.1 , 3.2 , 5.3 , 7.4 , 9.5 , 0.6 , 2.7 , 4.8 , 6.9 , 8 } ;
    double *wsk ;
    wsk = tablica ;
    cout << wsk << endl << wsk + 1 << endl ;
    cout << *wsk << " " << *( wsk + 1 ) << endl << endl ;
    wsk++;
    cout << wsk << endl << wsk+2 << endl ;
    cout << *wsk << " " << *( wsk + 2 ) << endl << endl ;
    wsk += 5 ;
    cout << wsk << endl << wsk-1 << endl ;
    cout << *wsk << " " << *( wsk-1 ) << endl << endl ;
    cout << wsk-tablica ;
    return 0 ;
}
