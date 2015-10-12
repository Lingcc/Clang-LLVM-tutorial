#include <tuple>
#include <iostream>
using namespace std;

tuple<int, int, int> foo (int &a , int &b, int c) {
	a++;
	b++;
	int e = a - b;
	int f = a * b;
	return make_tuple(e, f , a+b);
}

int main () {
	int a = 2;
	int b = 3;
	int d = 4;
	int c;
	int e = 0;
	int f;
	tie(c, e, f) = foo(a, b, d);
	cout << "a=" << a  << ", b=" << b << ", c=" << c 
	     <<", d" << d << ", e=" << e  << ", f=" << f <<  endl;
	return 0;
}
