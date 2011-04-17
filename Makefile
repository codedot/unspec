YFLAGS = -d
OBJS = \
	argv.o \
	exec.o \
	lexer.o \
	parser.o \
	var.o

all: sh test
	echo 'FOO=bar >output.txt PATH=.:/bin' \
			'./test hello <input.txt world' | \
		./sh | tee output.txt
	cmp output.txt expected.txt

sh: $(OBJS)

lexer.o: parser.o

$(OBJS): command.h

clean:
	-rm -f y.* *.o sh test output.txt
