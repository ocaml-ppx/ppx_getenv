build:
	dune build

test:
	dune runtest -f

clean:
	dune clean

.PHONY: build test clean
