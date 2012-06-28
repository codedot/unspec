#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void cmdname(char *path)
{
	assert(path);
	printf("The command name is \"%s\".\n", path);
	free(path);
}

void firstarg(char *arg)
{
	assert(arg);
	printf("The first argument is \"%s\".\n", arg);
	free(arg);
}

void lastarg(char *arg)
{
	assert(arg);
	printf("The last argument is \"%s\".\n", arg);
	free(arg);
}
