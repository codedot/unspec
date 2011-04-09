#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

void oomtest(const void *ptr, const char *str)
{
	if (!ptr) {
		assert(str);
		perror(str);
		exit(EXIT_FAILURE);
	}
}

void issuecmd(char *name, struct cmd *cmd)
{
	int i, argc;
	char **argv;

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
	}

	wait(NULL);

	argc = countarg(argv);
	for (i = 0; i < argc; i++)
		free(argv[i]);

	free(argv);
	free(cmd);
}
