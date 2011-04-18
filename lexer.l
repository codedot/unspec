%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

ASSIGN [_a-zA-Z][0-9_a-zA-Z]*=[^# \t\n<>&]*
UNSPEC [^# \t\n=<>&]*=[^# \t\n<>&]*
WORD [^# \t\n<>&][^# \t\n=<>&]*

%%

#.*|[ \t]+

\n return NEWLINE;

\< return LE;
\> return GR;
\<\< return LELE;
\>\> return GRGR;
\<& return LEAND;
\>& return GRAND;
\<\> return LEGR;
\<\<- return LELEDASH;
\>\| return CLOBBER;

{ASSIGN} {
	char *word = strdup(yytext);

	oomtest(word, "strdup");
	yylval.word = word;

	return ASSIGN;
}

{UNSPEC} {
	fprintf(stderr, "Unspecified: XCU 2.10.2 7b\n");
	exit(EXIT_FAILURE);
}

{WORD} {
	char *word = strdup(yytext);

	oomtest(word, "strdup");
	yylval.word = word;

	return WORD;
}

. return yytext[0];
