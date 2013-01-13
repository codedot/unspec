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

%X MAIN QUOTED TOKEN

%%

{EMPTY}+ |
\n+ ;

. {
	/*
	 * The lexer recognizes strings matching the regular
	 * expressions defined in the second section, that is
	 * one starting from the first line %% in the lexer.
	 * Each statement of this section is a rule of the form
	 * `ERE action', where ERE is extended regular expression
	 * with lex(1) utility additional options, while
	 * action is basically written in the C language with
	 * some additional variables and macros available.
	 *
	 * The additional actions supported by lex(1) include
	 * `|' for the action of the next rule, `;' to ignore,
	 * `BEGIN newstate' to switch the state of lexer to
	 * newstate, and int yyless(int n) routine which causes
	 * the string matching the regular expression starting
	 * from its nth character to be rescanned.
	 *
	 * The additional ERE options supported by lex(1) include
	 * `<CONDITION>' prefix which makes ERE match only
	 * in specific state of lexer, and `{NAME}' substitutions
	 * symbols defined in the first section of the lexer.
	 *
	 * The first three statements in this section do not have
	 * any condition specified, thus taking place in
	 * the initial state of the lexer.
	 * The purpose of these first three rules is to skip
	 * leading newlines along with blanks, comments, and
	 * line-joinings until an actual token is detected,
	 * according to XCU 2.3 Token Recognition rules.
	 * The matter is that NEWLINE tokens are not to be
	 * returned until an actual token is delimited.
	 * Once token is detected, the lexer is switched to
	 * a state MAIN in which the first three statements are
	 * disabled, because the state MAIN is defined as %X MAIN
	 * (eXclusive) in the first part of the lexer.
	 * The first character of the detected token is set to be
	 * rescanned by the lexer again (in the MAIN state).
	 */
	BEGIN MAIN;
	yyless(0);
}

<MAIN>{EMPTY}+ ;
<MAIN>\n return NEWLINE;
<MAIN>"&"{LJ}"&" return AND_IF;
<MAIN>"|"{LJ}"|" return OR_IF;
<MAIN>";"{LJ}";" return DSEMI;
<MAIN>"<"{LJ}"<"{LJ}"-" return DLESSDASH;
<MAIN>"<"{LJ}"<" return DLESS;
<MAIN>"<"{LJ}"&" return LESSAND;
<MAIN>"<"{LJ}">" return LESSGREAT;
<MAIN>">"{LJ}"&" return GREATAND;
<MAIN>">"{LJ}"|" return CLOBBER;
<MAIN>">"{LJ}">" return DGREAT;
<MAIN>[(<&|;>)] return yytext[0];

<MAIN>([0-9]{LJ})+/[<>] {
	/* XCU 2.10.1, item #3. */
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "IO_NUMBER '%s'\n", yylval.str);
	return IO_NUMBER;
}

<MAIN>. {
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
	BEGIN MAIN;
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
	BEGIN MAIN;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<QUOTED>{LJ}\"/[(<&|;>) \t\n] {
	BEGIN MAIN;
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
	BEGIN MAIN;
	yylval.str = chkptr(strdup(yytext), "strdup");
	fprintf(stderr, "WORD '%s'\n", yylval.str);
	return WORD;
}

<QUOTED>{LJ}{QLITER} yymore();
