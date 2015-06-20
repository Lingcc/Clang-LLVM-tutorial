// This code is licensed under the New BSD license.
// See LICENSE.txt for more details.
#include <iostream>

#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Host.h"
#include "llvm/ADT/IntrusiveRefCntPtr.h"

#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/FileSystemOptions.h"

#include "clang/Basic/SourceManager.h"
#include "clang/Lex/HeaderSearch.h"
#include "clang/Basic/FileManager.h"

#include "clang/Basic/TargetOptions.h"
#include "clang/Basic/TargetInfo.h"

#include "clang/Lex/Preprocessor.h"
#include "clang/Frontend/CompilerInstance.h"


/**
 * Tutorial1: PreProcessor Object Creation
 *   Clang make Preprocessor together with FE to improve performance.
 *   Here, the last line of the main function is to create a preprocessor object
 *   with the following parameters:
*     1. IntrusiveRefCntPtr< PreprocessorOptions > 	PPOpts: Options for the preprocessor.
 *    2. DiagnosticsEngine & 	diags: Used by clang to report errors and warnings to user.
 *      2.1 DiagnosticsConsume: The object that is actually displaying the messages t the user.
 *    3. LangOptions & 	opts: What language to process, C/C++/Obj-C.
 *    4. const TargetInfo * 	target:  Target of the assembly.
 *    5. SourceManager & 	SM: Used by Clang to load and cache source files.
 *    6. HeaderSearch & 	Headers: Configures where clang looks for include files.
 *    7. ModuleLoader & 	TheModuleLoader: Used to help resolve module names.
 */


int main()
{
  clang::DiagnosticOptions diagnosticOptions;
  clang::TextDiagnosticPrinter *pTextDiagnosticPrinter =
    new clang::TextDiagnosticPrinter(
				     llvm::outs(),
				     &diagnosticOptions,
				     true);
  llvm::IntrusiveRefCntPtr<clang::DiagnosticIDs> pDiagIDs;
    
  clang::DiagnosticsEngine *pDiagnosticsEngine =
    new clang::DiagnosticsEngine(pDiagIDs,
				 &diagnosticOptions,
				 pTextDiagnosticPrinter);

  clang::LangOptions languageOptions;
  clang::FileSystemOptions fileSystemOptions;
  clang::FileManager fileManager(fileSystemOptions);
  clang::SourceManager sourceManager(
				     *pDiagnosticsEngine,
				     fileManager);

  clang::TargetOptions* targetOptions = new clang::TargetOptions();
  targetOptions->Triple = llvm::sys::getDefaultTargetTriple();

  clang::TargetInfo *pTargetInfo = 
    clang::TargetInfo::CreateTargetInfo(
					*pDiagnosticsEngine,
  					std::make_shared<clang::TargetOptions>(*targetOptions));

  llvm::IntrusiveRefCntPtr<clang::HeaderSearchOptions> hso 
        = new clang::HeaderSearchOptions();

  clang::HeaderSearch headerSearch(hso,
                                   sourceManager,
				   *pDiagnosticsEngine,
				   languageOptions,
				   pTargetInfo);
  clang::CompilerInstance compInst;

  llvm::IntrusiveRefCntPtr<clang::PreprocessorOptions> pOpts;

  clang::Preprocessor preprocessor(
				   pOpts,
				   *pDiagnosticsEngine,
				   languageOptions,
				   sourceManager,
				   headerSearch,
				   compInst);

  return 0;
}
