%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

WORD [^# \t\n=<>]+

%%

#.*|[ \t\n]+

\< return LE;
\> return GR;
\<\< return LELE;
\>\> return GRGR;
\<& return LEAND;
\>& return GRAND;
\<\> return LEGR;
\<\<- return LELEDASH;
\>\| return CLOBBER;

{WORD} {
	char *word = strdup(yytext);

	oomtest(word, "strdup");
	yylval.word = word;

	return WORD;
}

. return yytext[0];
