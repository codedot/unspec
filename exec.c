#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

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

static void delcmd(struct cmd *cmd)
{
	char **argv;
	int i, argc;

	assert(cmd);
	argv = cmd->argv;

	assert(argv);
	argc = arraylen(argv);
	for (i = 0; i < argc; i++)
		free(argv[i]);

	free(argv);
	free(cmd);
}

void issuecmd(char *name, struct cmd *cmd)
{
	char **argv;
	int i, argc;

	if (!cmd)
		cmd = newcmd();

	assert(cmd);
	argv = cmd->argv;

	assert(argv);
	assert(name);
	argv[0] = name;

	if (!fork()) {
		execvp(name, argv);
		perror("execvp");
		exit(EXIT_FAILURE);
	} else {
		delcmd(cmd);
		wait(NULL);
	}
}
