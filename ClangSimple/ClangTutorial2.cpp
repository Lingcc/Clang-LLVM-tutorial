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

#include "clang/Basic/TargetOptions.h"
#include "clang/Basic/TargetInfo.h"

#include "clang/Lex/Preprocessor.h"
#include "clang/Frontend/CompilerInstance.h"

/**
 * Tutorial2: Tokenize a given File
 * 
 * After create the preprocessor object, this tutorial try to tokenize the source code.
 * Firstly, creat a file id for the input file and store it as "main file" in the 
 * SourceManager object, and tells the preprocessor to enter the main file of 
 * SourceManager into its file list, and does some other stuff ( like create
 * buffer with predifines),too.
 *
 * And then after the source file is added, we can ask the preprocessor to 
 * preprocess it and read the preprocessed input token.
 *
 * The preprocessor::Lex() will just pull a token from current lexer or macro object.
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


  const clang::FileEntry *pFile = fileManager.getFile("../Resources/test.c");
  sourceManager.setMainFileID(pFile);
  preprocessor.EnterMainSourceFile();
  pTextDiagnosticPrinter->BeginSourceFile(languageOptions, &preprocessor);

  clang::Token token;
  do {
    preprocessor.Lex(token);
    if( pDiagnosticsEngine->hasErrorOccurred())
      {
	break;
      }
    preprocessor.DumpToken(token);
    std::cerr << std::endl;
  } while( token.isNot(clang::tok::eof));
  pTextDiagnosticPrinter->EndSourceFile();

  return 0;
}
