#include <stdio.h>
//Przyk³adowa funkcja .
double fu (double x )
{
    return x/(x+10);
}
// Przyk³adowa funkcja, o b l i c z a w a r t o œæ w ielom ianu w p u nkc ie .
double wiel (double x )
{
    int i , st = 4 ;
    double wsp[5] ={1,0,0,1,0},wart=0, pow ;
    for ( i = 0 , pow = 1 ; i <= st;i++, pow *= x )
    wart +=wsp[i]*pow ;
    return wart ;
}
// Funkcja dzieli obszar pod wykresem funkcji w przedziale [a,b] na prostok¹ty
// szerokoœcih i sumuje pola takich prostok¹tów .
double polepodwykresem(double a , double b , double (* fu) (double) , double h )
{
    double suma = 0 ;
    for (;a<b;a+=h)
    suma += h*(fu(a)+fu(a+h))/2;
    return suma ;
}
double (*Fu(int n))(double)
{
    if(n==1) return fu;
    if(n==2) return wiel;
    return NULL;
}
typedef double (*Fn1Arg ) ( double ) ;

Fn1Arg Fn ( int n )
{
    if (n==1) return fu ;
    if (n==2) return wiel ;
    return NULL;
}
int main ( )
{
    int cyfry=10;
    printf("%lf\n" , polepodwykresem(-1,1,wiel,1.0/(1ll<<16)));
    return 0 ;
}

