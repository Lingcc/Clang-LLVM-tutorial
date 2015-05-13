/*
 * =============================================================================
 *
 *       Filename:  ReadBitCode.cpp
 *
 *    Description:  A code example to read LLVM bitcode intermodulely
 *
 *        Version:  1.0
 *        Created:  05/13/2015 07:00:50 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Kun Ling (), kunling@lingcc.com
 *   Organization:  Lingcc.com
 *
 * =============================================================================
 */
#include <iostream>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/ErrorOr.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/Bitcode/ReaderWriter.h>

using namespace llvm;

int main(int argc, char *argv[]) {
  if (argc != 2) {
    std::cerr << "Usage: " << argv[0] << "bitcode_filename" << std::endl;
    return 1;
  }
  StringRef filename = argv[1];
  LLVMContext context;

  ErrorOr<std::unique_ptr<MemoryBuffer>> fileOrErr =
    MemoryBuffer::getFileOrSTDIN(filename);
  if (std::error_code ec = fileOrErr.getError()) {
    std::cerr << " Error opening input file: " + ec.message() << std::endl;
    return 2;
  }
  ErrorOr<llvm::Module *> moduleOrErr =
      parseBitcodeFile(fileOrErr.get()->getMemBufferRef(), context);
  if (std::error_code ec = fileOrErr.getError()) {
    std::cerr << "Error reading Moduule: " + ec.message() << std::endl;
    return 3;
  }

  Module *m = moduleOrErr.get();
  std::cout << "Successfully read Module:" << std::endl;
  std::cout << " Name: " << m->getName().str() << std::endl;
  std::cout << " Target triple: " << m->getTargetTriple() << std::endl;

  for (auto iter1 = m->getFunctionList().begin();
       iter1 != m->getFunctionList().end(); iter1++) {
    Function &f = *iter1;
    std::cout << " Function: " << f.getName().str() << std::endl;
    for (auto iter2 = f.getBasicBlockList().begin();
         iter2 != f.getBasicBlockList().end(); iter2++) {
      BasicBlock &bb = *iter2;
      std::cout << "  BasicBlock: " << bb.getName().str() << std::endl;
      for (auto iter3 = bb.begin(); iter3 != bb.end(); iter3++) {
        Instruction &i = *iter3;
        std::cout << "   Instruction: " << i.getOpcodeName() << std::endl;
      }
    }
  }
  return 0;
}
