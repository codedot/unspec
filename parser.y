%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	struct cmd *cmd;
	char *word;
}

%token <word> WORD ASSIGN IONUM
%token LE GR LELE GRGR LEAND GRAND LEGR LELEDASH CLOBBER

%type <cmd> suffix
%type <word> name

%%

command: name {
	issuecmd($1, NULL);
} | name suffix {
	issuecmd($1, $2);
} | prefix | prefix name | prefix name suffix;

name: WORD;

prefix: redir | prefix redir | ASSIGN | prefix ASSIGN;

suffix: redir {
	$$ = NULL;
} | suffix redir | WORD {
	$$ = addarg(NULL, $1);
} | suffix WORD {
	$$ = addarg($1, $2);
};

redir: iofile | IONUM iofile | iohere | IONUM iohere;

iofile: LE file | LEAND file | GR file | GRAND file {
} | GRGR file | LEGR file | CLOBBER file;

file: WORD;

iohere: LELE hereend | LELEDASH hereend;

hereend: WORD;
