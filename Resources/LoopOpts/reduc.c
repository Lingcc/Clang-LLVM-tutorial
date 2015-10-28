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


int a[ARRAY_SIZE];
int b[ARRAY_SIZE];

int foo_a() {
  int i;
  int sum = 0;
  for (i=0; i < ARRAY_SIZE; i++) {
    sum += a[i];
  }
  return sum;
}


int foo_b() {
  int i;
  int sum = 0;
  for (i=0; i < ARRAY_SIZE; i++) {
    sum += b[i];
  }
  return sum;
}
void init_arr() {
  int i;
  for(i=0; i < ARRAY_SIZE; i++) {
    a[i] = 1;
  }
}

void copy_arr() {
  int i;
  for (i=0; i < ARRAY_SIZE; i++) {
    b[i] = a[i];
  }
  return;
}

int main() {
  init_arr();
  copy_arr();
  int res_a = foo_a();
  int res_b = foo_b();
  printf("result a:%d, result b:%d\n", res_a, res_b);
  return 0;
}
