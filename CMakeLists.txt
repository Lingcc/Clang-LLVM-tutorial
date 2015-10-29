cmake_minimum_required (VERSION 2.8)
project (ClangLLVMTutorial)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")


add_subdirectory(LLVMHelloWorld)
