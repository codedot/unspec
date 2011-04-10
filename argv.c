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

struct cmd *addarg(struct cmd *cmd, char *arg)
{
	char **argv;
	int argc;

	if (!cmd)
		cmd = newcmd();

	assert(cmd);
	argv = cmd->argv;
	argc = arraylen(argv);

	assert(arg);
	argv[argc] = arg;

	++argc;
	argv = (char **)realloc(argv, (argc + 1) * sizeof arg);
	argv[argc] = NULL;
	cmd->argv = argv;

	return cmd;
}

int arraylen(char **array)
{
	int len = 0;

	assert(array);
	while (array[len])
		++len;

	return len;
}
