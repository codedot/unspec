#include "command.h"

#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

static int fdout = -1;

void openout(char *file)
{
	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;

	if (-1 != fdout) {
		if (close(fdout)) {
			perror("close");
			exit(EXIT_FAILURE);
		}
		fdout = -1;
	}

	fdout = creat(file, mode);
	if (-1 == fdout) {
		perror("creat");
		exit(EXIT_FAILURE);
	}

	free(file);
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

	dup2(fdout, 1);
	close(fdout);
	execve(name, argv, envp);
	perror("execve");
	exit(EXIT_FAILURE);
}
