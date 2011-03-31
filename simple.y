%token WORD
%token ASSIGNMENT_WORD
%token IO_NUMBER
%token DLESS DGREAT LESSAND GREATAND LESSGREAT DLESSDASH
%token CLOBBER

%%

simple_command: cmd_prefix WORD cmd_suffix | cmd_prefix WORD |
	cmd_prefix | WORD cmd_suffix | WORD;

cmd_prefix: io_redirect | cmd_prefix io_redirect |
	ASSIGNMENT_WORD | cmd_prefix ASSIGNMENT_WORD;

cmd_suffix: io_redirect | cmd_suffix io_redirect | WORD |
	cmd_suffix WORD;

io_redirect: io_file | IO_NUMBER io_file | io_here |
	IO_NUMBER io_here;

io_file: '<' WORD | LESSAND WORD | '>' WORD | GREATAND WORD |
	DGREAT WORD | LESSGREAT WORD | CLOBBER WORD;

io_here: DLESS WORD | DLESSDASH WORD;
