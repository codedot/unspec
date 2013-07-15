%{
#include "y.tab.h"

#include "command.h"

#include <stdio.h>
#include <string.h>
%}

BLANK ([ \t])
LJ ((\\\n)*)
COMMENT ("#".*)
EMPTY ({BLANK}|{LJ}|{COMMENT})

CHAR ([^(<&|;>) $"'\\\t\n])
ESC (\\.)
QUOTE ('[^']*')
LITER ({CHAR}|{ESC}|{QUOTE})

%%

{EMPTY}+ ;

\n return NEWLINE;
"&"{LJ}"&" return AND_IF;
"|"{LJ}"|" return OR_IF;
";"{LJ}";" return DSEMI;
"<"{LJ}"<"{LJ}"-" return DLESSDASH;
"<"{LJ}"<" return DLESS;
"<"{LJ}"&" return LESSAND;
"<"{LJ}">" return LESSGREAT;
">"{LJ}"&" return GREATAND;
">"{LJ}"|" return CLOBBER;
">"{LJ}">" return DGREAT;
[$"`(<&|;>)] return yytext[0];

([0-9]{LJ})+/[<>] {
	/* XCU 2.10.1, item #3. */
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "IO_NUMBER '%s'\n", yylval.str);
	return IO_NUMBER;
}

({LITER}{LJ})+ {
	/*
	 * The yylval variable represents the token value.
	 * This variable is external variable for the lexer
	 * and is defined by the parser.
	 * Technically this variable has the union type.
	 * That union's fields are defined by the %union { ... }
	 * statement in the parser.
	 *
	 * In this particular case, the union has a field `str'
	 * of type (char *), and we assign the string accumulated
	 * in the yytext buffer as the token value.
	 * The string duplication is necessary due to yytext
	 * possibly modified before the token reaches the parser.
	 *
	 * The end-of-file is a valid token delimiter;
	 * see XCU 2.3 Token Recognition, item #1.
	 */
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}
