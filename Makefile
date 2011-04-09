YFLAGS = -d
OBJS = \
	argv.o \
	exec.o \
	lexer.o \
	parser.o

all: sh test
	echo date +%m/%d-%H%M | ./sh
	echo echo hello world | ./sh
	echo ./test 1 2 3 4 5 | ./sh

sh: $(OBJS)

lexer.o: parser.o

$(OBJS): command.h

clean:
	-rm -f y.* *.o sh test
