%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
%}

WORD [[:alnum:]]+

%%

#.*|[ \t\n]+

{WORD} {
	char *word = strdup(yytext);

	if (!word) {
		perror("strdup");
		exit(EXIT_FAILURE);
	}

	yylval.word = word;
	return WORD;
}

. return yytext[0];
