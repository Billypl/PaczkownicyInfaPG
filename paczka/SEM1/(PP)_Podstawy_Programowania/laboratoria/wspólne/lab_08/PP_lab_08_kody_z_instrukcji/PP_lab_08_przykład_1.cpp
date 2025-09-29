#include<iostream>
using namespace std ;
int main ( )
{
    int a = 1 , b = 2 , c = 3 ;
    int *wsk ;
    wsk = &a ;
    *wsk = a + 5 ;
    wsk = &b ;
    c = *wsk * 2 ;
    ++*wsk ;
    cout << a << " " << b << " " << c << " " << *wsk << endl ;
    return 0 ;
}

