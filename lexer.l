%{
#include "y.tab.h"
%}

WORD [[:alpha:]][[:alnum:]]*

%%

#.*|[ \t\n]+

{WORD} return WORD;

. return yytext[0];
