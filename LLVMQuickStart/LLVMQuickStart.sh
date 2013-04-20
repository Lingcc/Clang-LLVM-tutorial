#!/bin/sh

echo ">>>Diretly Compile HelloWorld into binary using LLVM"
echo ">>>> $ clang helloworld.c"
clang helloworld.c


echo ">>>Emit LLVM IR file Helloworld.bc based on the source code"
echo ">>>>$clang helloworld.c -emit-llvm -c -o helloworld.bc"
clang helloworld.c -emit-llvm -c -o helloworld.bc

echo ">>>Interpret the LLVM IR file using lli"
echo ">>>>$lli helloworld.bc"
lli helloworld.bc


echo ">>>Disassemble LLVM IR into reading format helloworld.bc.llir"
echo ">>>>llvm-dis helloworld.bc > helloworld.bc.llir"
llvm-dis < helloworld.bc > helloworld.bc.llir



