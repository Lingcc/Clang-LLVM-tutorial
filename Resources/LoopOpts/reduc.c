/*
 * =====================================================================================
 *
 *       Filename:  reduc.c
 *
 *    Description:  A simple reduction loop example
 *
 *        Version:  1.0
 *        Created:  05/13/2015 08:00:29 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Kun Ling (), kunling@lingcc.com
 *   Organization:  Lingcc.com
 *
 * =====================================================================================
 */

#include <stdio.h>

#define ARRAY_SIZE 100

int foo(int* a , int n) {
  int i;
  int sum = 0;
  for (; i < n; i++) {
    sum += a[i];
  }
  return sum;
}


int main() {
  int a[ARRAY_SIZE] = {1};

  int sum = foo(a, ARRAY_SIZE);

  printf("sum:0x%x\n", sum);
  return 0;
}
