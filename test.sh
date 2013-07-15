FOO=bar >output.txt PATH=.:/bin \
./demo hello#world <input.txt '$"`#\'
diff -u output.txt expect.txt
