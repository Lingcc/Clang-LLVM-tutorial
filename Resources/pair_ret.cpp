#include <tuple>
#include <iostream>
using namespace std;

pair<int, int> foo (int &a , int &b, int c) {
	a++;
	b++;
	int e = a - b;
	int f = a * b;
	return make_pair(e, f );
}

int main () {
	int a = 2;
	int b = 3;
	int d = 4;
	pair<int, int > c ;
	c = foo(a, b, d);
	cout << "a=" << a  << ", b=" << b << ", d=" << d 
	     <<", c.first" << c.first << ", c.second=" << c.second <<  endl;
	return 0;
}
