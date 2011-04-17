%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	char *word, **vec;
}

%token <word> WORD ASSIGN IONUM
%token LE GR LELE GRGR LEAND GRAND LEGR LELEDASH CLOBBER

%type <vec> prefix suffix

%%

command: prefix WORD suffix {
	issuecmd($2, $3, $1);
};

prefix: {
	$$ = NULL;
} | prefix redir | prefix ASSIGN {
	$$ = addvar($1, $2);
};

suffix: {
	$$ = NULL;
} | suffix redir | suffix WORD {
	$$ = addarg($1, $2);
};

redir: iofile /* | IONUM iofile | iohere | IONUM iohere */;

iofile: LE WORD {
	openin($2);
} /* | LEAND WORD */ | GR WORD {
	openout($2);
} /* | GRAND WORD | GRGR WORD | LEGR WORD | CLOBBER WORD */;

/* iohere: LELE hereend | LELEDASH hereend;

hereend: WORD; */
