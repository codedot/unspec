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

void issuecmd(char *path, struct cmd *cmd)
{
	int i;
	char **argv, **envp;

	assert(path);
	assert(cmd);
	argv = cmd->argv;
	envp = cmd->envp;

	if (!fork()) {
		execve(path, cmd->argv, cmd->envp);
		perror("execve");
		exit(EXIT_FAILURE);
	}

	wait(NULL);

	for (i = 0; argv[i]; i++)
		free(argv[i]);
	free(argv);

	for (i = 0; envp[i]; i++)
		free(envp[i]);
	free(envp);

	free(cmd);
	free(path);
}
