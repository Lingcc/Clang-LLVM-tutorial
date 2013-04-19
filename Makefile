CXX := clang++
LLVMCOMPONENTS := cppbackend
RTTIFLAG := -fno-rtti
LLVMCONFIG := llvm-config

CXXFLAGS := $(shell $(LLVMCONFIG) --cxxflags) $(RTTIFLAG)
LLVMLDFLAGS := $(shell $(LLVMCONFIG) --ldflags --libs $(LLVMCOMPONENTS))

SOURCES = ClangTutorial1.cpp \
    ClangTutorial2.cpp \
    ClangTutorial3.cpp \
    ClangTutorial4.cpp \
    ClangTutorial6.cpp \
    ClangCItutorial1.cpp \
    ClangCItutorial2.cpp \
    ClangCItutorial3.cpp \
    ClangCItutorial4.cpp \
    ClangCItutorial6.cpp \
    ClangCIBasicRecursiveASTVisitor.cpp \
    ClangCIrewriter.cpp \
		ClangToolingTutorial.cpp \
		ClangCommentHandling.cpp

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
