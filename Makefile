CXX := clang++
LLVMCOMPONENTS := cppbackend
RTTIFLAG := -fno-rtti
LLVMCONFIG := llvm-config

CXXFLAGS := $(shell $(LLVMCONFIG) --cxxflags) $(RTTIFLAG)
LLVMLDFLAGS := $(shell $(LLVMCONFIG) --ldflags --libs $(LLVMCOMPONENTS))

SOURCES = ClangSimple/ClangTutorial1.cpp \
    ClangSimple/ClangTutorial2.cpp \
    ClangSimple/ClangTutorial3.cpp \
    ClangSimple/ClangTutorial4.cpp \
    ClangSimple/ClangTutorial6.cpp \
    ClangCompilerInstance/ClangCItutorial1.cpp \
    ClangCompilerInstance/ClangCItutorial2.cpp \
    ClangCompilerInstance/ClangCItutorial3.cpp \
    ClangCompilerInstance/ClangCItutorial4.cpp \
    ClangCompilerInstance/ClangCItutorial6.cpp \
    ClangCompilerInstance/ClangCIBasicRecursiveASTVisitor.cpp \
    ClangCompilerInstance/ClangCIrewriter.cpp \
    ClangSimple/ClangToolingTutorial.cpp \
    ClangSimple/ClangCommentHandling.cpp \
    LLVMJIT/LLVMJIT1.cpp \
    LLVMJIT/LLVMJIT2.cpp

OBJECTS = $(SOURCES:.cpp=.o)
EXES = $(OBJECTS:.o=)
CLANGLIBS = \
    -lclangTooling\
    -lclangFrontendTool\
    -lclangFrontend\
    -lclangDriver\
    -lclangSerialization\
    -lclangCodeGen\
    -lclangParse\
    -lclangSema\
    -lclangStaticAnalyzerFrontend\
    -lclangStaticAnalyzerCheckers\
    -lclangStaticAnalyzerCore\
    -lclangAnalysis\
    -lclangARCMigrate\
    -lclangRewriteFrontend\
    -lclangRewriteCore\
    -lclangEdit\
    -lclangAST\
    -lclangLex\
    -lclangBasic\
    $(shell $(LLVMCONFIG) --libs)

all: $(OBJECTS) $(EXES)

%: %.o
	$(CXX) -o $@ $< $(CLANGLIBS) $(LLVMLDFLAGS)

clean:
	-rm -f $(EXES) $(OBJECTS) *~
