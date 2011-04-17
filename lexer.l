%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

ASSIGN [^# \t\n<>&]+=[^# \t\n<>&]*
WORD [^# \t\n=<>&]+

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

{WORD} {
	char *word = strdup(yytext);

	oomtest(word, "strdup");
	yylval.word = word;

	return WORD;
}

. return yytext[0];
