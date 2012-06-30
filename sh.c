#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	extern int yyparse();

	yyparse();

	return 0;
}

int yywrap(void)
{
	return 1;
}

int yyerror(const char *msg)
{
	fprintf(stderr, "%s\n", msg);
	return 0;
}
