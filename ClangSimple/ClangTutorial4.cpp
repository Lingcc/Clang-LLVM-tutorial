// This code is licensed under the New BSD license.
// See LICENSE.txt for more details.
#include <iostream>

#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Host.h"

#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/FileSystemOptions.h"

#include "clang/Basic/SourceManager.h"
#include "clang/Lex/HeaderSearch.h"
#include "clang/Basic/FileManager.h"

#include "clang/Frontend/Utils.h"

#include "clang/Basic/TargetOptions.h"
#include "clang/Basic/TargetInfo.h"

#include "clang/Lex/Preprocessor.h"
#include "clang/Frontend/FrontendOptions.h"

#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/Builtins.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/Sema/Sema.h"

#include "clang/Parse/ParseAST.h"
#include "clang/Parse/Parser.h"
#include "clang/Frontend/CompilerInstance.h"

/**
 * Tutorial4: Parsing the file
 * 
 * Finally, we come to the parsing. This is done by calling to clang::ParseAST().
 * This function have parameter:
 *   1. Preprocessor &PP, 
 *   2. ASTConsumer *Consumer,
 *   3. ASTContext &Ctx
 *   4. CodeCompleteConsumer *CompletionConsumer,
 *   5. TranslationUnitKind TUKind
 *
 *
 */

int main()
{
  clang::DiagnosticOptions diagnosticOptions;
  clang::TextDiagnosticPrinter *pTextDiagnosticPrinter =
    new clang::TextDiagnosticPrinter(
				     llvm::outs(),
				     &diagnosticOptions);
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

  llvm::IntrusiveRefCntPtr<clang::HeaderSearchOptions> headerSearchOptions(new clang::HeaderSearchOptions());
  // <Warning!!> -- Platform Specific Code lives here
  // This depends on A) that you're running linux and
  // B) that you have the same GCC LIBs installed that
  // I do. 
  // Search through Clang itself for something like this,
  // go on, you won't find it. The reason why is Clang
  // has its own versions of std* which are installed under 
  // /usr/local/lib/clang/<version>/include/
  // See somewhere around Driver.cpp:77 to see Clang adding
  // its version of the headers to its include path.
  headerSearchOptions->AddPath("/usr/include/linux",
			       clang::frontend::Angled,
			       false,
			       false);
  headerSearchOptions->AddPath("/usr/include/c++/4.4/tr1",
			       clang::frontend::Angled,
			       false,
			       false);
  headerSearchOptions->AddPath("/usr/include/c++/4.4",
			       clang::frontend::Angled,
			       false,
			       false);
  // </Warning!!> -- End of Platform Specific Code

  clang::TargetOptions targetOptions;
  targetOptions.Triple = llvm::sys::getDefaultTargetTriple();

  clang::TargetInfo *pTargetInfo = 
    clang::TargetInfo::CreateTargetInfo(
					*pDiagnosticsEngine,
					&targetOptions);

  llvm::IntrusiveRefCntPtr<clang::HeaderSearchOptions> hso;
  clang::HeaderSearch headerSearch(hso,
				   fileManager, 
				   *pDiagnosticsEngine,
				   languageOptions,
				   pTargetInfo);
  clang::CompilerInstance compInst;

  llvm::IntrusiveRefCntPtr<clang::PreprocessorOptions> pOpts( new clang::PreprocessorOptions());
  clang::Preprocessor preprocessor(
				   pOpts,
				   *pDiagnosticsEngine,
				   languageOptions,
				   pTargetInfo,
				   sourceManager,
				   headerSearch,
				   compInst);

  clang::FrontendOptions frontendOptions;
  clang::InitializePreprocessor(
				preprocessor,
				*pOpts,
				*headerSearchOptions,
				frontendOptions);
        
  const clang::FileEntry *pFile = fileManager.getFile("../Resources/test.c");
  sourceManager.createMainFileID(pFile);

  const clang::TargetInfo &targetInfo = *pTargetInfo;

  clang::IdentifierTable identifierTable(languageOptions);
  clang::SelectorTable selectorTable;

  clang::Builtin::Context builtinContext;
  builtinContext.InitializeTarget(targetInfo);
  clang::ASTContext astContext(
			       languageOptions,
			       sourceManager,
			       pTargetInfo,
			       identifierTable,
			       selectorTable,
			       builtinContext,
			       0 /* size_reserve*/);
  clang::ASTConsumer astConsumer;

  clang::Sema sema(
		   preprocessor,
		   astContext,
		   astConsumer);

  pTextDiagnosticPrinter->BeginSourceFile(languageOptions, &preprocessor);
  clang::ParseAST(preprocessor, &astConsumer, astContext); 
  pTextDiagnosticPrinter->EndSourceFile();
  identifierTable.PrintStats();

  return 0;
}
