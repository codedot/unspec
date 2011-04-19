%{
#include "y.tab.h"

#include "command.h"

#include <stdlib.h>
%}

ASSIGN [_a-zA-Z][0-9_a-zA-Z]*=[^# \t\n<>&]*
UNSPEC [^# \t\n=<>&]*=[^# \t\n<>&]*
WORD [^# \t\n<>&][^# \t\n=<>&]*

%%

#.*|[ \t]+

[0-9]+/[<>] {
	yylval.num = atoi(yytext);
	return IONUM;
}

"<<" return LELE;
">>" return GRGR;
"<&" return LEAND;
">&" return GRAND;
"<>" return LEGR;
"<<-" return LELEDASH;
">|" return CLOBBER;

{ASSIGN} {
	yylval.word = copyword(yytext);
	return ASSIGN;
}

{UNSPEC} {
	yylval.word = copyword(yytext);
	return UNSPEC;
}

{WORD} {
	yylval.word = copyword(yytext);
	return WORD;
}

\n|. return yytext[0];
