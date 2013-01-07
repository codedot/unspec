#include "command.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void unspec(const char *ref)
{
	assert(ref);
	fprintf(stderr, "Unspecified: %s\n", ref);
	exit(EXIT_FAILURE);
}

void *chkptr(void *ptr, const char *cause)
{
	if (!ptr) {
		perror(cause);
		exit(EXIT_FAILURE);
	}

	return ptr;
}
