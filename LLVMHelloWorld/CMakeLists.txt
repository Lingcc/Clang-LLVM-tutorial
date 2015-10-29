cmake_minimum_required(VERSION 2.8.8)

add_library(LLVMHelloWorldPass MODULE LLVMHelloWorldPass.cpp)
add_llvm_loadable_module(LLVMHelloWorldPass
  LLVMHelloWorldPass.cpp
  )
