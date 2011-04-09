%{
#include "command.h"

#include <stdio.h>
#include <stdlib.h>
%}

%union {
	struct command *command;
	char *word;
}

%token <word> WORD ASSIGNMENT_WORD IO_NUMBER
%token DLESS DGREAT LESSAND GREATAND LESSGREAT DLESSDASH CLOBBER

%type <command> cmd_suffix
%type <word> cmd_name

%%

simple_command: cmd_name {
	issuecmd($1, NULL);
} | cmd_name cmd_suffix {
	issuecmd($1, $2);
} | cmd_prefix | cmd_prefix cmd_word {
} | cmd_prefix cmd_word cmd_suffix;

cmd_name: WORD;

cmd_word: WORD;

cmd_prefix: io_redirect | cmd_prefix io_redirect {
} | ASSIGNMENT_WORD | cmd_prefix ASSIGNMENT_WORD;

cmd_suffix: io_redirect {
	$$ = NULL;
} | cmd_suffix io_redirect | WORD {
	$$ = firstarg($1);
} | cmd_suffix WORD {
	$$ = lastarg($1, $2);
};

io_redirect: io_file | IO_NUMBER io_file | io_here {
} | IO_NUMBER io_here;

io_file: '<' filename | LESSAND filename | '>' filename {
} | GREATAND filename | DGREAT filename | LESSGREAT filename {
} | CLOBBER filename;

filename: WORD;

io_here: DLESS here_end | DLESSDASH here_end;

here_end: WORD;
