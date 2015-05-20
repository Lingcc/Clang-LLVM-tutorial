#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "iostream"
#include "llvm/Pass.h"
#include "llvm/IR/InstIterator.h"
#include <llvm/IR/Instructions.h>
#include <llvm/Analysis/LoopInfo.h>


using namespace llvm;


namespace {
  struct LoopInfoPass : public FunctionPass {
    static char ID; // Pass identification, replacement for typeid
    LoopInfoPass() : FunctionPass(ID) {}

    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.setPreservesCFG();
      AU.addRequired<LoopInfoWrapperPass>();
    }
    bool runOnFunction(Function &F) override {
      LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
      errs().write_escaped(F.getName());
      errs() << " : ";
      for( Function::iterator b = F.begin() , be = F.end(); b != be; ++b){
        errs() << "\n\t BB : ";
        bool isLoop = LI.getLoopFor(b);
        if(isLoop){
          errs() << "loop{";
        }
        for(BasicBlock::iterator i = b->begin() , ie = b->end(); i!=ie; ++i){
          if( isa<CallInst>(&(*i)) || isa<InvokeInst>(&(*i))){
            errs() << cast<CallInst>(&(*i))->getCalledFunction()->getName() << "\t";
          }
        }
        if(isLoop){
          errs() << "}";
        }
     }
     errs() << '\n';
     return false;
   }
  };
}

char LoopInfoPass::ID = 0;
static RegisterPass<LoopInfoPass> X("loopinfopass", "Gen Loop info and CFG",true ,true);
