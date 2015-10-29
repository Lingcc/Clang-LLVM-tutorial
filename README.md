[![Build Status](https://travis-ci.org/Lingcc/Clang-LLVM-tutorial.svg?branch=master)](https://travis-ci.org/Lingcc/Clang-LLVM-tutorial)
# About #
This is a collection of examples showing off how to use core Clang and LLVM. It is based directly on two older tutorials which no longer built due to code rot. It will try to make anyone who is interested in LLVM and Clang could dig into them as soon as possible.

This project forked from [loarabia / Clang-tutorial](https://github.com/loarabia/Clang-tutorial), and extend it for not only more Clang tutorial cases, but also plenty of LLVM tutorials cases, and we have also adjust the source code layout.

It contains:

1. LLVMQuickStart
2. LLVMJIT
3. ClangSimple
4. ClangCompilerInstance

*Status*:All the codes have been tested by LLVM SVN Trunk r179830(2013-4-20).

The project webpage is [here](http://lingcc.github.io/Clang-LLVM-tutorial)


## LLVMQuickStart
 This tutorial is for get a first impression of  llvm tools like clang, lli, llvm-dis, etc.

## LLVMJIT
 This tutorial is used to know how the LLVM IR is created and assemed.

## ClangSimple
 It is used to know how to create a preprocessor, lexer and parser based on Clang Front End.
 It uses the basic interfaces and classes.

## ClangCompilerInstance
 It can help to know how to use the CompilerInstance class for preprocessor, lexer and parser creation.

# Credit
All these cases comes from, or derived from the following project and web post.

1. [Getting Started with the LLVM System](http://llvm.org/docs/GettingStarted.html ) from LLVM.org
2. [llvm-tutorials](https://github.com/fabriceleal/llvm-tutorials)  from fabriceleal
3. [llvm_tutorial](https://github.com/r7kamura/llvm_tutorials) from r7kamura
4. [kaleidoscope](https://github.com/maxsnew/kaleidoscope) from maxsnew
5. [tutorial 1](http://amnoid.de/tmp/clangtut/tut.html) by Nico Weber - 9/28/2008
6. [tutorial 2](http://www.cs.rpi.edu/~laprej/clang.html) by Justin LaPre at Rensselaer Polytechnic Institute - 10/20/2009
7. [tutorial 3](https://github.com/loarabia/Clang-tutorial/wiki/TutorialOrig) by Larry Olson - 4/14/2012


This particular set of tutorials tracks the llvm / clang mainline and is updated semi-regularly to account for llvm / clang API changes.
# Other Options #
The Clang team has been hard at work making it easier to write tools using Clang. There are [4 options](http://clang.llvm.org/docs/Tooling.html) for developing tools using clang and llvm infrastructure.

# Latest Stable LLVM / Clang (v3.7) #
The master branch tracks recent commits to the clang and llvm svn. The tutorial assumes you have grabbed a copy of both llvm and clang by following [these instructions](http://clang.llvm.org/get_started.html) and that have installed the the resulting binaries by running `make install`. If you want the latest public release, then checkout the *3.7* branch.

    git clone git@github.com:Lingcc/Clang-LLVM-tutorial.git
    git checkout 3.7

# CI tutorials #
The tutorials prefixed with CI are the same as the original tutorials but use the [CompilerInstance](http://clang.llvm.org/doxygen/classclang_1_1CompilerInstance.html) object and its helper methods to perform the same tasks as the original tutorials. For the most part, this makes the code much more compact.


# Contact Me #
For any questions, you can:
- ping me on github
- email me kunling@lingcc.com

