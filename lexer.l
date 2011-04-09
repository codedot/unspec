%{
#include "y.tab.h"

#include <stdio.h>
#include <stdlib.h>
%}

WORD [^# \t\n=<>]+

%%

#.*|[ \t\n]+

\<\< return DLESS;
\>\> return DGREAT;
\<& return LESSAND;
\>& return GREATAND;
\<\> return LESSGREAT;
\<\<- return DLESSDASH;
\>\| return CLOBBER;

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
