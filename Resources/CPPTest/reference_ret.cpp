#include <iostream>
using namespace std;

int foo (int &a , int &b, int c) {
	a++;
	b++;
	return a+b;
}

int main () {
	int a = 2;
	int b = 3;
	int d = 4;
	int c = foo(a, b, d);
	cout << "a=" << a  << ", b=" << b << ", c=" << c << ", d=" << d << endl;
	return 0;
}
