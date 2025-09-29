#include<iostream>
using namespace std;
int main(int argc, char * argv[])
{
	permutuj(argv[0]);
	cout << argv[0];
}
void permutuj(char wyraz[])
{
	//ta permutacja jest za ma³o losowa
	char temp;
	temp = wyraz[2];
	wyraz[2] = wyraz[5];
	wyraz[5] = temp;
	return;
}
