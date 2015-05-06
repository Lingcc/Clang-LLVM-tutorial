/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description:  A testcase used for ClangTypeSize detector to detect the size of 
 *                  each type
 *
 *        Version:  1.0
 *        Created:  05/04/2015 07:17:40 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Kun Ling (), kunling@lingcc.com
 *   Organization:  Lingcc.com
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <complex.h>

int main() {
  char a = 2;
  int  b = 0xf;
  const int c = 0xefff;
  long long d = 0xffffffffff;
  float e = 112.0;
  double f = 32.0;
  float _Complex g = 2.0 + 3.0 * I;
  double _Complex h = 3232.32 + 23*I;
  long double _Complex i = 32323 + 0*I;
  float _Complex j = 0 + 3.0 * I;
  printf("size of a,b,c,d,e,f,g,h,i,j is"
        "%d %d %d %d %d %d %d %d %d %d\n",
        sizeof(a), sizeof(b), sizeof(c), sizeof(d),
        sizeof(e), sizeof(f), sizeof(g), sizeof(h),
        sizeof(i), sizeof(j));
  return 0;
}
