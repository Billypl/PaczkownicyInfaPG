#include<iostream>
#include<cmath>
using namespace std;
void zagadka(int set_size)
{
	int sub_num = (1 << set_size);
	for(int i=0;i<sub_num;i++)
	{
		cout << "{";
		for(int j=1,el=0;j<sub_num;j*=2,el++)		
			if(j & i) cout << el <<" ";
		cout << "}" << endl;
	}
}
int main()
{
	int n;
	cout << "Podaj n: ";
	cin >> n;
	zagadka(n);
	return 0;
}
