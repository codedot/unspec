%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	char **argv, **envp;
	char *word;
	void *unused;
}

%token <word> WORD ASSIGN IONUM
%token <unused> LE GR LELE GRGR LEAND GRAND LEGR LELEDASH CLOBBER

%type <envp> prefix
%type <word> file
%type <argv> suffix
%type <unused> redir iofile

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

iofile: LE file {
	openin($2);
} /* | LEAND file */ | GR file {
	openout($2);
} /* | GRAND file | GRGR file | LEGR file | CLOBBER file */;

file: WORD;

/* iohere: LELE hereend | LELEDASH hereend;

hereend: WORD; */
