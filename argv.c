#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void oomtest(const void *ptr, const char *str)
{
	if (!ptr) {
		assert(str);
		perror(str);
		exit(EXIT_FAILURE);
	}
}

int arraylen(char **array)
{
	int len = 0;

	assert(array);
	while (array[len])
		++len;

	return len;
}

char **newargv(void)
{
	char **argv = (char **)calloc(sizeof *argv, 2);
	
	oomtest(argv, "calloc");
	argv[0] = "";

	return argv;
}

char **addarg(char **argv, char *arg)
{
	int argc;

	if (!argv)
		argv = newargv();

	argc = arraylen(argv) + 1;
	argv = (char **)realloc(argv, (argc + 1) * sizeof arg);
	argv[argc - 1] = arg;
	argv[argc] = NULL;

	return argv;
}
