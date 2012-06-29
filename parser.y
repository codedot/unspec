%{
#include <stdio.h>
%}

%union {
	char *word;
}

%token <word> WORD ASSIGNMENT_WORD IO_NUMBER
%token DLESS DGREAT LESSAND GREATAND LESSGREAT DLESSDASH CLOBBER

%%

simple_command: cmd_name | cmd_name cmd_suffix | cmd_prefix |
	cmd_prefix cmd_word | cmd_prefix cmd_word cmd_suffix;

cmd_name: WORD {
	printf("Command:\n\t%s\n", $1);
};

cmd_word: WORD;

cmd_prefix: io_redirect | cmd_prefix io_redirect |
	ASSIGNMENT_WORD | cmd_prefix ASSIGNMENT_WORD;

cmd_suffix: io_redirect | cmd_suffix io_redirect | WORD {
	printf("Arguments:\n\t%s\n", $1);
} | cmd_suffix WORD {
	printf("\t%s\n", $2);
};

io_redirect: io_file | IO_NUMBER io_file | io_here |
	IO_NUMBER io_here;

io_file: '<' filename | LESSAND filename | '>' filename |
	GREATAND filename | DGREAT filename |
	LESSGREAT filename | CLOBBER filename;

filename: WORD;

io_here: DLESS here_end | DLESSDASH here_end;

here_end: WORD;
