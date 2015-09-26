#!/bin/bash

LLVM_SRC_DIR="llvm_src_all"
if [ ! -d "$LLVM_SRC_DIR" ]; then
  echo ">>> Clone llvm to $LLVM_SRC_DIR"
  git clone http://llvm.org/git/llvm.git $LLVM_SRC_DIR 
else
  echo ">>> git pull $LLVM_SRC_DIR"
  cd $LLVM_SRC_DIR && git pull &
fi

CLANG_SRC_DIR="$LLVM_SRC_DIR/tools/clang"
if [ ! -d "$CLANG_SRC_DIR" ]; then
    echo ">>> git clone $CLANG_SRC_DIR"
    git clone http://llvm.org/git/clang.git $CLANG_SRC_DIR 
else
    echo ">>> git pull $CLANG_SRC_DIR"
    cd $CLANG_SRC_DIR && git pull &
fi

COMPILER_RT_SRC_DIR="$LLVM_SRC_DIR/projects/compiler-rt"
if [ ! -d "$COMPILER_RT_SRC_DIR" ]; then
    echo ">>> git clone $COMPILER_RT_SRC_DIR"
    git clone http://llvm.org/git/compiler-rt.git $COMPILER_RT_SRC_DIR 
else
    echo ">>> git pull $COMPILER_RT_SRC_DIR"
    cd $COMPILER_RT_SRC_DIR && git pull &
fi


TESTSUITE_SRC_DIR="$LLVM_SRC_DIR/projects/test-suite"
if [ ! -d "$TESTSUITE_SRC_DIR" ]; then
    echo ">>> git clone $TESTSUITE_SRC_DIR"
    git clone http://llvm.org/git/test-suite.git $TESTSUITE_SRC_DIR 
else
    echo ">>> git pull $TESTSUITE_SRC_DIR"
    cd $TESTSUITE_SRC_DIR && git pull &
fi

wait
echo ">>> git clone/pull done, start configure, make, make install"

LLVM_BUILD_DIR="llvm_build"
mkdir -p $LLVM_BUILD_DIR && cd $LLVM_BUILD_DIR
bash -c "cmake ../$LLVM_SRC_DIR -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${HOME}/usr/ -DLLVM_TARGETS_TO_BUILD=all -DLLVM_BUILD_TESTS=ON -DLLVM_ENABLE_RTTI=ON " >& run_config.log
bash -c "cmake --build ." >& run_make_all.log
#bash -c "cmake --build . --target check-all" >& run_make_all.log
bash -c "cmake --build . --target install" >& run_make_all.log
