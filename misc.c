#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void unspec(const char *ref)
{
	assert(ref);
	fprintf(stderr, "Unspecified: %s\n", ref);
	exit(EXIT_FAILURE);
}

int veclen(char **vec)
{
	int len = 0;

	assert(vec);
	while (vec[len])
		++len;

	return len;
}

void oomtest(const void *ptr, const char *str)
{
	if (!ptr) {
		assert(str);
		perror(str);
		exit(EXIT_FAILURE);
	}
}

char *copyword(const char *word)
{
	char *copy = strdup(word);

	oomtest(copy, "strdup");
	
	return copy;
}
