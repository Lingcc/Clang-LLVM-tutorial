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

int my_func( int arg1) {
  int x = arg1;
  return x+1;
}

int main() {
  int a = 11;
  int b = 22;
  int c = 33;
  int d = 44;
  if ( a > 10 ) {
    b = c;
  } else {
    b = my_func(d);
  }
  return b;
}

