#!/bin/bash
LLVM_SRC_DIR="llvm_src_all"
echo ">>> git pull $LLVM_SRC_DIR"
cd $LLVM_SRC_DIR && git pull &

CLANG_SRC_DIR="$LLVM_SRC_DIR/tools/clang"
echo ">>> git pull $CLANG_SRC_DIR"
cd $CLANG_SRC_DIR && git pull &

COMPILER_RT_SRC_DIR="$LLVM_SRC_DIR/projects/compiler-rt"
echo ">>> git pull $COMPILER_RT_SRC_DIR"
cd $COMPILER_RT_SRC_DIR && git pull &


TESTSUITE_SRC_DIR="$LLVM_SRC_DIR/projects/test-suite"
echo ">>> git pull $TESTSUITE_SRC_DIR"
cd $TESTSUITE_SRC_DIR && git pull &

wait
echo ">>> git pull done, start configure, make, make install"

LLVM_BUILD_DIR="llvm_build"
mkdir -p $LLVM_BUILD_DIR && cd $LLVM_BUILD_DIR
bash -c "../$LLVM_SRC_DIR/configure --prefix=${HOME}/usr/" >& run_config.log
bash -c "make -j5" >& run_make_all.log
bash -c "make check-all" >& run_make_check_all.log 
bash -c "make install" >& run_make_install.log
