YFLAGS = -d

OBJS = \
	lexer.o \
	parser.o \
	sh.o

all: sh

check: sh test
	echo 'FOO=bar >output.txt PATH=.:/bin' \
		'./test hello <input.txt world' | ./sh
	cmp output.txt expect.txt

sh: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) -ly -ll

lexer.o: y.tab.h

y.tab.h: parser.o

clean:
	-rm -f lexer.c parser.c y.*
	-rm -f output.txt sh test *.o
