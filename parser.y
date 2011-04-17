%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	char **argv, **envp;
	char *word;
	void **unused;
}

%token <word> WORD ASSIGN IONUM
%token <unused> LE GR LELE GRGR LEAND GRAND LEGR LELEDASH CLOBBER

%type <envp> prefix
%type <word> name file
%type <argv> suffix
%type <unused> redir iofile

%%

command: name {
	issuecmd($1, NULL, NULL);
} | name suffix {
	issuecmd($1, $2, NULL);
} | prefix | prefix name {
	issuecmd($2, NULL, $1);
} | prefix name suffix {
	issuecmd($2, $3, $1);
};

name: WORD;

prefix: redir {
	$$ = NULL;
} | prefix redir | ASSIGN {
	$$ = addvar(NULL, $1);
} | prefix ASSIGN {
	$$ = addvar($1, $2);
};

suffix: redir {
	$$ = NULL;
} | suffix redir | WORD {
	$$ = addarg(NULL, $1);
} | suffix WORD {
	$$ = addarg($1, $2);
};

redir: iofile /* | IONUM iofile | iohere | IONUM iohere */;

iofile: LE file /* | LEAND file */ | GR file {
	openout($2);
} /* | GRAND file | GRGR file | LEGR file | CLOBBER file */;

file: WORD;

/* iohere: LELE hereend | LELEDASH hereend;

hereend: WORD; */
