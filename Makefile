YFLAGS = -d
OBJS = \
	argv.o \
	exec.o \
	lexer.o \
	misc.o \
	open.o \
	parser.o \
	var.o

all: sh

check: sh test
	echo 'FOO=bar >output.txt PATH=.:/bin' \
		'./test hello <input.txt world' | ./sh
	cmp output.txt expect.txt

sh: $(OBJS)

lexer.o: parser.o

$(OBJS): command.h

clean:
	-rm -f y.* *.o sh test output.txt
