#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct cmd *firstarg(char *arg)
{
	struct cmd *cmd = (struct cmd *)malloc(sizeof *cmd);
	char **argv = (char **)calloc(sizeof *argv, 3);
	char **envp = (char **)calloc(sizeof *envp, 1);
	
	oomtest(cmd, "malloc");
	oomtest(argv, "calloc");
	oomtest(envp, "calloc");
	cmd->argv = argv;
	cmd->envp = envp;

	assert(arg);
	argv[0] = strdup("");
	argv[1] = arg;

	return cmd;
}

struct cmd *lastarg(struct cmd *cmd, char *arg)
{
	char **argv;
	int argc;

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
	int i, argc = 0;

	assert(argv);
	for (i = 0; argv[i]; i++)
		++argc;

	return argc;
}
