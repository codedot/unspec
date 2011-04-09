#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct cmd *newcmd(void)
{
	struct cmd *cmd = (struct cmd *)malloc(sizeof *cmd);
	char **argv = (char **)calloc(sizeof *argv, 2);
	
	oomtest(cmd, "malloc");
	oomtest(argv, "calloc");
	argv[0] = "";
	cmd->argv = argv;

	return cmd;
}

struct cmd *addarg(struct cmd *cmd, char *arg)
{
	char **argv;
	int argc;

	if (!cmd)
		cmd = newcmd();

	assert(cmd);
	argv = cmd->argv;
	argc = countarg(argv);

	assert(arg);
	argv[argc] = arg;

	++argc;
	argv = (char **)realloc(argv, (argc + 1) * sizeof arg);
	argv[argc] = NULL;
	cmd->argv = argv;

	return cmd;
}

int countarg(char **argv)
{
	int argc = 0;

	assert(argv);
	while (argv[argc])
		++argc;

	return argc;
}
