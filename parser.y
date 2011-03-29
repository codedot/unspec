%token WORD
%token ASSIGNMENT_WORD
%token NAME
%token NEWLINE
%token IO_NUMBER

%token AND_IF OR_IF DSEMI
%token DLESS DGREAT LESSAND GREATAND LESSGREAT DLESSDASH
%token CLOBBER
%token If Then Else Elif Fi Do Done
%token Case Esac While Until For
%token Lbrace Rbrace Bang
%token In

%%

complete_command: list separator | list;
list: list separator_op and_or | and_or;
and_or: pipeline | and_or AND_IF linebreak pipeline |
	and_or OR_IF linebreak pipeline;
pipeline: pipe_sequence | Bang pipe_sequence;
pipe_sequence: command | pipe_sequence '|' linebreak command;
command: simple_command | compound_command |
	compound_command redirect_list |
	NAME '(' ')' linebreak function_body;
compound_command: Lbrace compound_list Rbrace |
	'(' compound_list ')' | for_clause | case_clause |
	if_clause | While compound_list do_group |
	Until compound_list do_group;
compound_list: term | newline_list term | term separator |
	newline_list term separator;
term: term separator and_or | and_or;
for_clause: For NAME linebreak do_group |
	For NAME linebreak In sequential_sep do_group |
	For NAME linebreak In wordlist sequential_sep do_group;
do_group: Do compound_list Done;
wordlist: wordlist WORD | WORD;
case_clause: Case WORD linebreak In linebreak case_list Esac |
	Case WORD linebreak In linebreak case_list_ns Esac |
	Case WORD linebreak In linebreak Esac;
case_list_ns: case_list case_item_ns | case_item_ns;
case_list: case_list case_item | case_item;
case_item_ns: pattern ')' linebreak |
	pattern ')' compound_list linebreak |
	'(' pattern ')' linebreak |
	'(' pattern ')' compound_list linebreak;
case_item: pattern ')' linebreak DSEMI linebreak |
	pattern ')' compound_list DSEMI linebreak |
	'(' pattern ')' linebreak DSEMI linebreak |
	'(' pattern ')' compound_list DSEMI linebreak;
pattern: WORD | pattern '|' WORD;
if_clause: If compound_list Then compound_list else_part Fi |
	If compound_list Then compound_list Fi;
else_part: Elif compound_list Then else_part |
	Else compound_list;
function_body: compound_command | compound_command redirect_list;
simple_command: cmd_prefix WORD cmd_suffix | cmd_prefix WORD |
	cmd_prefix | WORD cmd_suffix | WORD;
cmd_prefix: io_redirect | cmd_prefix io_redirect |
	ASSIGNMENT_WORD | cmd_prefix ASSIGNMENT_WORD;
cmd_suffix: io_redirect | cmd_suffix io_redirect | WORD |
	cmd_suffix WORD;
redirect_list: io_redirect | redirect_list io_redirect;
io_redirect: io_file | IO_NUMBER io_file | io_here |
	IO_NUMBER io_here;
io_file: '<' WORD | LESSAND WORD | '>' WORD | GREATAND WORD |
	DGREAT WORD | LESSGREAT WORD | CLOBBER WORD;
io_here: DLESS WORD | DLESSDASH WORD;
newline_list: NEWLINE | newline_list NEWLINE;
linebreak: newline_list |;
separator_op: '&' | ';';
separator: separator_op linebreak | newline_list;
sequential_sep: ';' linebreak | newline_list;
