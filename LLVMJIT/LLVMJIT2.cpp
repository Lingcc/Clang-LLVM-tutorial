#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/PassManager.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/Analysis/Verifier.h>
#include <llvm/Assembly/PrintModulePass.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/Support/raw_ostream.h>
#include <iostream>

/*
  This is our goal:


*/ 

using namespace llvm;
using namespace std;

/** 
 *  LLVMJIT1: Create a LLVM module for the following function
 *  unsigned gcd(unsigned x, unsigned y) {
 *      if(x == y) {
 *          return x;
 *      } else if(x < y) {
 *          return gcd(x, y -x);
 *      } else {
 *         return gcd(x - y, y);
 *      }
 *  }
 * BasicBlock::Create(): Create a basic block.
 * IRBuilder::CreateCondBr()
 */


Module* makeLLVMModule() {
  Module* mod = new Module("tut2", getGlobalContext());

  Constant* c = mod->getOrInsertFunction(
					 "gcd",
					 IntegerType::get(getGlobalContext(), 32),
					 IntegerType::get(getGlobalContext(), 32),
					 IntegerType::get(getGlobalContext(), 32),
					 NULL);
  Function* gcd = cast<Function>(c);

  gcd->setCallingConv(CallingConv::C);

  Function::arg_iterator args = gcd->arg_begin();
  Value* x = args++;
  x->setName("x");
  Value* y = args++;
  y->setName("y");

  // This example has branching, so we create a block for 
  // each "section" of code
  BasicBlock* entry = BasicBlock::Create(getGlobalContext(), "entry", gcd);
  BasicBlock* ret = BasicBlock::Create(getGlobalContext(), "return", gcd);
  BasicBlock* cond_false = BasicBlock::Create(getGlobalContext(), "cond_false", gcd);
  BasicBlock* cond_true = BasicBlock::Create(getGlobalContext(), "cond_true", gcd);
  BasicBlock* cond_false_2 = BasicBlock::Create(getGlobalContext(), "cond_false_2", gcd);

  // ** entry **
  IRBuilder<> builder(entry);
  // Integer comparison for equality, returns a 1 bit integer result
  Value* xEqualsY = builder.CreateICmpEQ(x, y, "tmp");
  builder.CreateCondBr(xEqualsY, ret, cond_false);

  // ** ret **
  builder.SetInsertPoint(ret);
  builder.CreateRet(x);

  // ** cond_false **
  builder.SetInsertPoint(cond_false);
  // Integer comparison for unsigned less-than
  Value* xLessThanY = builder.CreateICmpULT(x, y, "tmp");
  builder.CreateCondBr(xLessThanY, cond_true, cond_false_2);

  // ** cond_true **
  builder.SetInsertPoint(cond_true);
  Value* yMinusX = builder.CreateSub(y, x, "tmp");
  std::vector<Value*> args1_vec;
  args1_vec.push_back(x);
  args1_vec.push_back(yMinusX);
  ArrayRef<Value*> args1(args1_vec);
  Value* recur_1 = builder.CreateCall(gcd, args1, "tmp");
  builder.CreateRet(recur_1);

  // ** cond_false_2 **
  builder.SetInsertPoint(cond_false_2);
  Value* xMinusY = builder.CreateSub(x, y, "tmp");
  std::vector<Value*> args2_vec;
  args2_vec.push_back(xMinusY);
  args2_vec.push_back(y);
  ArrayRef<Value*> args2(args2_vec);
  Value* recur_2 = builder.CreateCall(gcd, args2, "tmp");
  builder.CreateRet(recur_2);

  return mod;
}

int main(int argc, char** argv) {
  Module* Mod = makeLLVMModule();

  verifyModule(*Mod, PrintMessageAction);

  PassManager PM;
  PM.add(createPrintModulePass(&outs()));
  PM.run(*Mod);

  delete Mod;
  return 0;
}
