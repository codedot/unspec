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

NAME ([A-Za-z_]({LJ}[A-Za-z_0-9])*)
PARAM ([0-9!$\-?#*@])
PAREXP (${LJ}({PARAM}|{NAME}))

QCHAR ([^"\\$])
CHAR ([^(<&|;>) $"'\\\t\n])
ESC (\\.)
QUOTE ('[^']*')
CMDQUOTE (`([^`\\]|{LJ}|{ESC})*`)
QLITER ({QCHAR}|{ESC}|{CMDQUOTE}|{PAREXP})
LITER ({CHAR}|{ESC}|{QUOTE}|{CMDQUOTE}|{PAREXP})

%X QUOTED TOKEN

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

([0-9]{LJ})+/[<>] {
	/* XCU 2.10.1, item #3. */
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "IO_NUMBER '%s'\n", yylval.str);
	return IO_NUMBER;
}

. {
	/* XCU 2.3, item #11. */
	BEGIN TOKEN;
	yyless(0);
}

<TOKEN>{LJ}\" {
	/*
	 * Double-quoted field is to be handled under special
	 * exclusive start condition called QUOTED.
	 * A yymore() call makes the next token to be appended to
	 * yytext variable rather than replacing its value.
	 */
	BEGIN QUOTED;
	yymore();
}

<TOKEN>{LJ}{LITER}/[(<&|;>) \t\n] {
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
	 */
	BEGIN INITIAL;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<TOKEN>{LJ}{LITER}/. yymore();

<TOKEN>{LJ}{LITER} {
	/*
	 * The end-of-file is a valid token delimiter;
	 * see XCU 2.3 Token Recognition, item #1.
	 * This action is assumed to be taken at the end
	 * of input because neither of the previous regular
	 * expressions matched the current input.
	 */
	BEGIN INITIAL;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<QUOTED>{LJ}\"/[(<&|;>) \t\n] {
	BEGIN INITIAL;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<QUOTED>{LJ}\"/. {
	/*
	 * According to XCU 2.3, item #4, the token is not to be
	 * delimited by the end of the quoted field.
	 */
	BEGIN TOKEN;
	yymore();
}

<QUOTED>{LJ}\" {
	BEGIN INITIAL;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<QUOTED>{LJ}{QLITER} yymore();
