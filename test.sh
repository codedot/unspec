FOO=bar >output.txt PATH=.:/bin \
./demo hello#world <input.txt `echo \`echo foo#bar\``
diff -u output.txt expect.txt
