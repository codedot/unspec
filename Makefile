YFLAGS = -d

all: sh
	echo echo hello world | ./sh

sh: parser.o lexer.o

lexer.o: parser.o

clean:
	-rm -f y.* *.o sh
