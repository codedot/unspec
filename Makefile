YFLAGS = -d

all: sh
	echo echo hello world | ./sh

test: sh
	echo 'FOO=bar >output.txt PATH=.:/bin' \
		'./test hello <input.txt world' | ./sh
	cmp output.txt expect.txt

sh: parser.o lexer.o

lexer.o: parser.o

clean:
	-rm -f y.* *.o sh test output.txt
