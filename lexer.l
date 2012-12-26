%{
#include "y.tab.h"
%}

WORD [[:alpha:]][[:alnum:]]*

%%

#.*|[ \t\n]+ ;

{WORD} {
	/*
	 * The yylval variable represents the token value.
	 * This variable is external variable for the lexer
	 * and is defined by the parser.
	 * Technically this variable has the union type.
	 * That union's fields are defined by the %union { ... }
	 * statement in the parser.
	 *
	 * The lexer recognizes strings matching the regular
	 * expressions defined in the second section, that is
	 * one starting from the first line %% in the lexer.
	 * Each statement of this section is a rule of the form
	 * `REGEXP actions;', where REGEXP is either a regular
	 * expression or `{NAME}' (the regular expression
	 * defined in the first section of the lexer), while
	 * actions are basically written in the C language with
	 * some additional variables and macros available.
	 *
	 * In this particular case, the union has a field `str'
	 * of type (char *), and we assign the string matching
	 * the regular expression named WORD as the token value.
	 */
	yylval.str = yytext;

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
