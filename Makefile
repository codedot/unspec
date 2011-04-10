YFLAGS = -d
OBJS = \
	argv.o \
	exec.o \
	lexer.o \
	parser.o \
	var.o

all: sh test
	echo ./test hello world | ./sh

sh: $(OBJS)

lexer.o: parser.o

$(OBJS): command.h

clean:
	-rm -f y.* *.o sh test
