%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	int num;
	char *word, **vec;
}

%token <num> IONUM LEGR GRGR LELE LELEDASH LEAND GRAND CLOBBER
%token <word> WORD UNSPEC ASSIGN

%%

command: prefix '\n' {
	exit(EXIT_SUCCESS);
} | prefix WORD suffix '\n' {
	issuecmd($2, $<vec>3, $<vec>1);
};

prefix: {
	$<vec>$ = NULL;
} | prefix redir | prefix UNSPEC {
	unspec("XCU 2.10.2 7b");
} | prefix ASSIGN {
	$<vec>$ = addvar($<vec>1, $2);
};

suffix: {
	$<vec>$ = NULL;
} | suffix redir | suffix arg {
	$<vec>$ = addarg($<vec>1, $<word>2);
};

arg: WORD | ASSIGN | UNSPEC;

redir: redirsym WORD {
	openio(-1, $<num>1, $2);
} | IONUM redirsym WORD {
	openio($1, $<num>2, $3);
};

redirsym: '<' {
	$<num>$ = INPUT;
} | LEGR {
	$<num>$ = INOUTPUT;
} | '>' {
	$<num>$ = OUTPUT;
} | GRGR {
	$<num>$ = APPEND;
} | CLOBBER {
	$<num>$ = FORCEOUT;
} | LELE {
	$<num>$ = HEREDOC;
} | LELEDASH {
	$<num>$ = HEREIND;
} | LEAND {
	$<num>$ = DUPIN;
} | GRAND {
	$<num>$ = DUPOUT;
};
