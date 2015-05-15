/*
 * =====================================================================================
 *
 *       Filename:  foo.c
 *
 *    Description:  Test input file for Intermodule Bitcode reader.
 *
 *        Version:  1.0
 *        Created:  05/13/2015 07:31:14 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Kun Ling (), kunling@lingcc.com
 *   Organization:  Lingcc.com
 *
 * =====================================================================================
 */

struct a {
  int f_a;
  int f_b;
  char f_c:5;
  char f_d:4;
};

int my_func( int arg1, struct a obj_a) {
  int x = arg1;
  return x+1 + obj_a.f_c;
}

int main() {
  int a = 11;
  int b = 22;
  int c = 33;
  int d = 44;
  struct a obj_a;
  obj_a.f_a = 1;
  obj_a.f_b = 2;
  obj_a.f_c = 3;
  obj_a.f_c = 4;
  if ( a > 10 ) {
    b = c;
  } else {
    b = my_func(d, obj_a);
  }
  return b;
}

