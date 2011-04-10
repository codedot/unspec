#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char **newenvp(void)
{
	char **envp = (char **)calloc(sizeof *envp, 1);
	
	oomtest(envp, "calloc");

	return envp;
}

char **addvar(char **envp, char *var)
{
	int len;

	if (!envp)
		envp = newenvp();

	len = arraylen(envp) + 1;
	envp = (char **)realloc(envp, (len + 1) * sizeof var);
	envp[len - 1] = var;
	envp[len] = NULL;

	return envp;
}
