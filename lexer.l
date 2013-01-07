%{
#include "y.tab.h"
%}

CHAR ([^(<&|;>) "'\\\t\n])
ESC (\\[^\n])
QUOTE ('[^']*')
DQUOTE (\"([^"\\]|{LJ}|\\.)*\")
LITER ({CHAR}|{ESC}|{QUOTE}|{DQUOTE})
WORD ({LITER}({LJ}{LITER})*)

BLANK ([ \t])
LJ ((\\\n)*)
COMMENT ("#"[^\n]*)
EMPTY ({BLANK}|{LJ}|{COMMENT})

%X MAIN

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

<MAIN>[0-9]+/[<>] {
	yylval.str = yytext;

	return IO_NUMBER;
}

<MAIN>{WORD} {
	/*
	 * The yylval variable represents the token value.
	 * This variable is external variable for the lexer
	 * and is defined by the parser.
	 * Technically this variable has the union type.
	 * That union's fields are defined by the %union { ... }
	 * statement in the parser.
	 *
	 * In this particular case, the union has a field `str'
	 * of type (char *), and we assign the string matching
	 * the regular expression named WORD as the token value.
	 */
	yylval.str = yytext;

	return WORD;
}

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

<MAIN>. return yytext[0];
