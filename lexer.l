%{
#include "y.tab.h"

#include "command.h"

#include <stdio.h>
#include <string.h>

#define TOKENIZE(TOKEN) \
	do { \
		yylval.str = chkptr(strdup(yytext), "strdup"); \
		fprintf(stderr, #TOKEN " '%s'\n", yylval.str); \
		return TOKEN; \
	} while (0)
%}

BLANK ([ \t])
LJ ((\\\n)*)
COMMENT ("#".*)
EMPTY ({BLANK}|{LJ}|{COMMENT})

NAME ([A-Za-z_]({LJ}[A-Za-z_0-9])*)
PARAM ([0-9!$\-?#*@])
PAREXP (${LJ}({PARAM}|{NAME}))

CHAR ([^(<&|;>) $"'\\\t\n])
ESC (\\.)
QUOTE ('[^']*')
CMDQUOTE (`([^`\\]|{LJ}|{ESC})*`)
LITER ({CHAR}|{ESC}|{QUOTE}|{CMDQUOTE}|{PAREXP})

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
[(<&|;>)] return yytext[0];

([0-9]{LJ})+/[<>] TOKENIZE(IO_NUMBER);
{LITER}({LJ}{LITER})* TOKENIZE(WORD);
