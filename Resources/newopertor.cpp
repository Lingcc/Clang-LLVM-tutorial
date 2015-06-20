#include <iostream>




using namespace std;

class foo {
private:
  int _a;
  char _b;

public:
  foo() {
    _a = 0;
    _b = 'a';
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }

  foo(int a, int b) {
    _a = a ;
    _b = b;
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
  ~foo() {
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
};


class foo2 {
private:
  int _a;
  char _b;

public:
  foo2(int a, int b) {
    _a = a ;
    _b = b;
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
  ~foo2() {
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
};



class bar {
private:
  int _a;
  int _b;
public:
  bar() {
    _a = 0;
    _b = 'b';
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
  ~bar() {
    cout << "call " << __func__ << ", " <<__FUNCTION__ << "," << __PRETTY_FUNCTION__ << endl;
  }
};

int main() {
  foo* foo_obj = new foo();
  foo* foo_obj2 = new foo;
  foo2* foo2_obj = new foo2(2, 3);
  //  foo2* foo2_obj2 = new foo2;
  bar* bar_obj = new bar();
  bar* bar_obj2 = new bar;
  
}

  
  
