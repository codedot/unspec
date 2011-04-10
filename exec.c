#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

static void delarray(char **array)
{
	int i, len;

	assert(array);
	len = arraylen(array);

	for (i = 0; i < len; i++)
		free(array[i]);

	free(array);
}

void issuecmd(char *name, char **argv, char **envp)
{
	if (!envp)
		envp = newenvp();
	if (!argv)
		argv = newargv();

	assert(envp);
	assert(argv);
	assert(name);
	argv[0] = name;

	if (!fork()) {
		execve(name, argv, envp);
		perror("execve");
		exit(EXIT_FAILURE);
	} else {
		delarray(argv);
		delarray(envp);
		wait(NULL);
	}
}
