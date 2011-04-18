%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	char *word, **vec;
}

%token <word> WORD UNSPEC ASSIGN IONUM
%token LE GR LELE GRGR LEAND GRAND LEGR LELEDASH CLOBBER NEWLINE

%type <vec> prefix suffix
%type <word> arg

%%

command: prefix NEWLINE {
	exit(EXIT_SUCCESS);
} | prefix WORD suffix NEWLINE {
	issuecmd($2, $3, $1);
};

prefix: {
	$$ = NULL;
} | prefix redir | prefix UNSPEC {
	fprintf(stderr, "Unspecified: XCU 2.10.2 7b\n");
} | prefix ASSIGN {
	$$ = addvar($1, $2);
};

suffix: {
	$$ = NULL;
} | suffix redir | suffix arg {
	$$ = addarg($1, $2);
};

arg: WORD | ASSIGN | UNSPEC;

redir: iofile | IONUM iofile | iohere | IONUM iohere;

iofile: LE WORD {
	openin($2);
} | GR WORD {
	openout($2);
} | GRGR WORD {
} | LEGR WORD {
} | CLOBBER WORD {
} | LEAND WORD {
} | GRAND WORD {
};

iohere: LELE WORD {
} | LELEDASH WORD {
};
