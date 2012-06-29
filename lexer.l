%{
#include "y.tab.h"
%}

WORD [[:alpha:]][[:alnum:]]*

%%

#.*|[ \t\n]+ /* Ignore comments and spaces */

{WORD} {
	yylval.word = yytext;
	return WORD;
}

\<\< return DLESS;
\>\> return DGREAT;
\<& return LESSAND;
\>& return GREATAND;
\<\> return LESSGREAT;
\<\<- return DLESSDASH;
\>\| return CLOBBER;

. return yytext[0];
