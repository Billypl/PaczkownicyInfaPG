 // Test program for C
int a;                 // declaration of one variable
float a1, _b, _00;        // declaration of 3 variables
double PI = 3.1415926;        // declaration of variable with initialization
unsigned char c;
int fromASCII = 128, toASCII = 255;
int t[10];
struct data {
  int year;
  int month, day;
} d;
void EmptyFunction( void )
{
}
int EmptyFunctionWithParameters( int a, double d )
{
}
float FunctionWithDeclarationOfVariables( double d )
{ // declaractio of variables
    int a;
    double half = .5;
    int t[7];
    struct data {
      int year, month;
      int day;
    } d1;
}
int x1 = fromASCII + 2 * ( 20 +  toASCII ); 
double realTest = 12.34 + .56 + 78.;
void main( void )
{
    int a = 1, b, c, m;
    int t[3];
    struct data {
      int day, month, year;
    } d;
 
    EmptyFunction(); 
    EmptyFunctionWithParameters( "x", 123, 12.34 );
    printf( "\n\n\nExtended ASCII codes\n\n" );
    // for loop
    for ( uc = fromASCII; uc <= toASCII; uc1++ )
    {
        int a;
        int t[2];
        t[0] = 1; t[1] = t[0];
        printf( "%3d:%2c", uc, uc );
        printf(",%d\n",t[1]);
        d.day = 1;
    }
    // conditional instruction
    if ( a > 10 )
        b = a;
    if ( a > 1 )
        b = a;
    else
        b = 1;
    if ( a > b )
        if ( a > c )
            m = a;
        else
            m = c;
    else
        if ( b > c )
            m = b;
        else
            m = c;
    while (a > 1)
            a = a - 2;
    d.year = 2010;
    do {
      a++; d.year++;
    } while (a < 1);
    m = a > b ? (a > c ? a : c) : (b > c ? b : c);
}