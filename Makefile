YFLAGS = -d
OBJS = \
	argv.o \
	execve.o \
	lexer.o \
	parser.o

all: sh
	echo echo hello world | ./sh

sh: $(OBJS)

lexer.o: parser.o

clean:
	-rm -f y.* *.o sh
