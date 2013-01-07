FOO=bar >output.txt PATH=.:/bin \
./demo hello <input.txt world
cmp output.txt expect.txt
