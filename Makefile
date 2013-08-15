YFLAGS = -dtv

OBJS = \
	lexer.o \
	parser.o \
	unspec.o

all: sh test.sh demo input.txt expect.txt
	./sh <test.sh
	-diff -u output.txt expect.txt

sh: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) -ly -ll

$(OBJS): command.h

lexer.o: y.tab.h

y.tab.h: parser.o

clean:
	-rm -f lexer.c parser.c y.*
	-rm -f output.txt sh demo *.o
