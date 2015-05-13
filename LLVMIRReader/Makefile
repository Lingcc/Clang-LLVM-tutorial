# A LLVMIR Reader example for IR reading intermodulely by taking advantage
# of Module's  getFunctionList() interface.
all:
	# Get the binary for IR reader
	clang++ ReadBitCode.cpp -o reader `llvm-config --cxxflags --libs --ldflags --system-libs`
	# Emit bitcode for the test file
	clang -emit-llvm -o foo.bc -c foo.c
	# Run the reader
	./reader foo.bc

test:
	# Check whether it works as expected
	./reader foo.bc > test.out
	@if diff test.out test.expected ; then \
		echo "PASS" ; \
	else \
		echo "FAIL" ; \
	fi

clean:
	-rm foo.bc
	-rm reader
	-rm test.out
	-rm *~
