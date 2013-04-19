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
#include "clang/Frontend/CompilerInstance.h"

/**
 * Tutorial3: Add default include file search dir
 * 
 * After create the preprocessor object, tokenize the source code,
 * this toturial want to add the default system header paths to clang.
 * 
 * This is done by creating a default HeaderSearchOptions.
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


    clang::TargetOptions targetOptions;
    targetOptions.Triple = llvm::sys::getDefaultTargetTriple();
    clang::TargetInfo *pTargetInfo = 
        clang::TargetInfo::CreateTargetInfo(
            *pDiagnosticsEngine,
            &targetOptions);

    llvm::IntrusiveRefCntPtr<clang::HeaderSearchOptions> hso(new clang::HeaderSearchOptions());
    clang::HeaderSearch headerSearch(hso,
                                     fileManager, 
                                     *pDiagnosticsEngine,
                                     languageOptions,
                                     pTargetInfo);
    clang::CompilerInstance compInst;

    llvm::IntrusiveRefCntPtr<clang::PreprocessorOptions> pOpts;
    clang::Preprocessor preprocessor(
        pOpts,
        *pDiagnosticsEngine,
        languageOptions,
        pTargetInfo,
        sourceManager,
        headerSearch,
        compInst);

    clang::PreprocessorOptions preprocessorOptions;

    clang::FrontendOptions frontendOptions;
    clang::InitializePreprocessor(
        preprocessor,
        preprocessorOptions,
        *hso,
        frontendOptions);

    // Note: Changed the file from tutorial2.
    const clang::FileEntry *pFile = fileManager.getFile("testInclude.c");
    sourceManager.createMainFileID(pFile);
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
