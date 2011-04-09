#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void issuecmd(char *path, struct command *command)
{
	assert(path);
	printf("The command name is \"%s\".\n", path);
	free(path);
}

struct command *firstarg(char *arg)
{
	assert(arg);
	printf("The first argument is \"%s\".\n", arg);
	free(arg);

	return NULL;
}

struct command *lastarg(struct command *command, char *arg)
{
	assert(arg);
	printf("The last argument is \"%s\".\n", arg);
	free(arg);

	return command;
}
