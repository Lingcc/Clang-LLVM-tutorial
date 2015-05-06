==============================
 Note about Adding a new Pass
==============================


Reading the Docs Notes
======================

All LLVM passes are subclasses of the ``Pass`` class.
LLVM have implement the several different passes.
It is better for a new pass to derive from any of the following passes:


The base class have the following virtual methods which need to implement.
1. ``ModulePass``
2.  ``CallGraphSCCPass``
3.  ``FunctionPass``
4.  ``LoopPass``
5.  ``RegionPass``
6.  ``BasicBlockPass``


The doc is about writing a "hello world" pass.


Makefile writing for a new Pass


Each pass has its own directory, usually in the ``lib/Transforms`` directory.
And based on LLVM's existing Makefile structure, the code of the pass, including
all the ``.cpp`` files in the current directory will be compiled and linked
to a shared object ``.so`` file in ``Debug+Asserts/lib`` directory.

Such ``.so`` file will be used by ``opt`` and ``bugpoint`` tool of llvm with
``-load`` option.


The pass's main entry ``.cpp`` file should have the following code. 

.. highlight:: cpp
	       #include "llvm/Pass.h"
	       #include "llvm/IR/Function.h"
	       #include "llvm/Support/raw_ostream.h"
	       using namespace llvm;

The doc is about processing functions, therefore a class derived
from ``FunctionPass`` is created.

LLVM uses ``ID`` 's address to identify a pass.

CPP programming note

1. ``;`` is only used at ``class`` and ``struct`` defination.
   ``namespace`` defination does not use it.

2. ``override`` is used in the code, what is it? Why use it here?
   Is it a c++ keyword?

   This means such defination overrides an abstract virtual method
   inherited from ``FunctionPass``.

3. ``Hello() : FunctionPass(ID)``: What does this mean?
