#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

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

	dup2(fdin, 0);
	close(fdin);
	dup2(fdout, 1);
	close(fdout);

	execve(name, argv, envp);
	perror("execve");
	exit(EXIT_FAILURE);
}
