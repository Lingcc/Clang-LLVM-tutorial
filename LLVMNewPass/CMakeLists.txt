cmake_minimum_required(VERSION 3.0)
find_package(LLVM REQUIRED CONFIG)
SET(CMAKE_CXX_FLAGS "-Wall -fno-rtti -Wextra -std=c++11")

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(HelloPass)
